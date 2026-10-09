# Calculate chmod=0755
#!/bin/bash

variable_value() {
    /usr/libexec/calculate/cl-variable --value "$@"
}

log() {
    printf '%s %s\n' "$(date '+%F %T')" "$*"
}

escape_re() {
    printf '%s' "$1" | sed 's/[][^$.\\*+?(){}|]/\\&/g'
}

get_domain() {
    local d
    d=$(variable_value client.os_remote_auth)
    [[ -n $d ]] || d=$(sed -nE 's/^[[:space:]]*ad_domain[[:space:]]*=[[:space:]]*([a-zA-Z0-9.-]+).*/\1/p' "$SSSD_CONF" 2>/dev/null | head -n1)
    [[ -n $d ]] || d=$(variable_value client.cl_remote_host)
    [[ -n $d && ! $d =~ ^[0-9.]+$ ]] && printf '%s' "$d"
}

CHECK_INTERVAL=60
SYNC_INTERVAL=$((6 * 3600))
CMD_TIMEOUT=300
SSSD_CONF=${SSSD_CONF:-/etc/sssd/sssd.conf}

declare -A NEXT_SYNC
declare -A LAST_STATE
DOMAIN=""
DOMAIN_RE=""
CONF_DC=""
CAND_DC=""
LAST_RAW=""
LOGGED_NO_DC=0

logged_users() {
    if command -v loginctl &>/dev/null; then
        loginctl list-sessions --no-legend 2>/dev/null |
            awk '{print $1}' | while read -r sid; do
                [[ $(loginctl show-session "$sid" -p Class --value 2>/dev/null) = user ]] || continue
                [[ $(loginctl show-session "$sid" -p State --value 2>/dev/null) =~ ^(active|online)$ ]] || continue
                loginctl show-session "$sid" -p Name --value 2>/dev/null
            done
    else
        who | awk '{print $1}'
    fi | grep -vx root | sort -u
}

current_dc_number() {
    timeout 20 /usr/sbin/adcli info -D "$DOMAIN" 2>/dev/null |
        sed -nE 's/^[[:space:]]*domain-controller[[:space:]]*=[[:space:]]*[a-zA-Z]*([0-9]+)\..*/\1/p' |
        head -n1
}

update_dc_state() {
    local cand=$1
    LAST_RAW=$cand
    if [[ -z $cand ]]; then
        CAND_DC=""
        if [[ -n $CONF_DC && $LOGGED_NO_DC -eq 0 ]]; then
            log "DC number unavailable (adcli error or unsupported DC name format)"
            LOGGED_NO_DC=1
        fi
    elif [[ $cand != "$CONF_DC" ]]; then
        if [[ $cand == "$CAND_DC" ]]; then
            [[ -n $CONF_DC ]] &&
                log "DC switched: dc$CONF_DC -> dc$cand" ||
                log "current DC: dc$cand"
            CONF_DC=$cand
            CAND_DC=""
            LOGGED_NO_DC=0
        else
            CAND_DC=$cand
        fi
    else
        CAND_DC=""
    fi
}

user_mounts() {
    local login_re=$1
    findmnt -rn -t cifs -o SOURCE,TARGET 2>/dev/null |
        grep -iE "^//$DOMAIN_RE/(share|users/$login_re)/?[[:space:]]"
}

is_mounted() {
    findmnt -rn -t cifs -o SOURCE 2>/dev/null | grep -qiE "^//$1/?$"
}

is_mounted_users() {
    local re=$1
    findmnt -rn -t cifs -o SOURCE,OPTIONS 2>/dev/null |
        grep -qiE "^//$DOMAIN_RE/users/$re/?([[:space:]]|$)|^//$DOMAIN_RE/users[[:space:]].*[,[:space:]]username=$re([,[:space:]]|$)"
}

missing_mounts() {
    local login=$1 login_re miss=()
    login_re=$(escape_re "$login")
    is_mounted "$DOMAIN_RE/share" || miss+=(share)
    is_mounted_users "$login_re" || miss+=("users/$login")
    printf '%s' "${miss[*]}"
}

failure_reason() {
    local dc=$1 login=$2 host uid cc
    [[ -n $dc ]] || { printf 'no confirmed DC (adcli failed or switching)'; return; }
    host="smb$dc.$DOMAIN"
    getent hosts "$host" >/dev/null 2>&1 || { printf 'DNS: %s not resolved' "$host"; return; }
    if ! timeout 5 bash -c "exec 3<>/dev/tcp/$host/445" 2>/dev/null; then
        printf 'unreachable %s:445' "$host"
        return
    fi
    uid=$(id -u "$login" 2>/dev/null)
    if [[ -z $uid ]]; then
        printf 'uid for %s not resolved' "$login"
        return
    fi
    local found=0
    for cc in $(ls -1dt /tmp/krb5cc_"$uid" /tmp/krb5cc_"$uid"_* 2>/dev/null); do
        klist -s -c "FILE:$cc" 2>/dev/null && { found=1; break; }
    done
    if (( ! found )); then
        printf 'no Kerberos TGT for %s' "$login"
        return
    fi
    printf '%s reachable, cause unclear' "$host"
}

umount_stale() {
    local login=$1 dc=$2 src target n changed=1
    while read -r src target; do
        [[ -n $src ]] || continue
        n=$(sed -nE 's#^//[a-zA-Z]*([0-9]+)\..*#\1#p' <<< "$src")
        [[ -n $n && $n != "$dc" ]] || continue
        if umount "$target" &>/dev/null; then
            log "$login: stale umount $target (src $src, current dc$dc)"
        elif umount -l "$target" &>/dev/null; then
            log "$login: stale lazy umount $target (src $src, current dc$dc)"
        else
            log "$login: FAILED to umount $target (src $src)"
        fi
        changed=0
    done < <(user_mounts "$(escape_re "$login")")
    return $changed
}

run_sync() {
    local login=$1 rc
    shift
    timeout "$CMD_TIMEOUT" cl-client-sync-login "$@" "$login"
    rc=$?
    if (( rc == 124 )); then
        log "$login: sync killed, timeout ${CMD_TIMEOUT}s"
    elif (( rc != 0 )); then
        log "$login: sync failed rc=$rc"
    fi
    return $rc
}

log "watchdog started: check ${CHECK_INTERVAL}s, sync ${SYNC_INTERVAL}s"

while true; do
    mapfile -t USERS < <(logged_users)

    for u in "${!NEXT_SYNC[@]}"; do
        printf '%s\n' "${USERS[@]}" | grep -Fxq "$u" || unset "NEXT_SYNC[$u]"
    done
    for u in "${!LAST_STATE[@]}"; do
        printf '%s\n' "${USERS[@]}" | grep -Fxq "$u" || unset "LAST_STATE[$u]"
    done

    new_domain=$(get_domain)
    if [[ $new_domain != "$DOMAIN" ]]; then
        if [[ -z $new_domain ]]; then
            log "domain is not set, waiting for configuration"
        elif [[ -n $DOMAIN ]]; then
            log "domain changed: $DOMAIN -> $new_domain"
        else
            log "domain: $new_domain"
        fi
        DOMAIN=$new_domain
        DOMAIN_RE="[^/]*$(escape_re "$DOMAIN")"
    fi
    [[ -n $DOMAIN ]] || { sleep "$CHECK_INTERVAL"; continue; }

    update_dc_state "$(current_dc_number)"

    now=$SECONDS
    for login in "${USERS[@]}"; do
        [[ -n $login ]] || continue
        [[ -n ${NEXT_SYNC[$login]} ]] || NEXT_SYNC[$login]=$((now + SYNC_INTERVAL))

        state=$(missing_mounts "$login")
        state=${state:-ok}
        if [[ ${LAST_STATE[$login]} != "$state" ]]; then
            if [[ $state == ok ]]; then
                log "$login: mounts ok"
            else
                log "$login: mounts missing: $state; cause: $(failure_reason "$CONF_DC" "$login")"
            fi
            LAST_STATE[$login]=$state
        fi

        if [[ $state != ok ]]; then
            run_sync "$login" --no-sync on --renew-ticket off
        elif [[ -n $CONF_DC && $LAST_RAW == "$CONF_DC" ]] &&
            umount_stale "$login" "$CONF_DC"; then
            run_sync "$login" --no-sync on --renew-ticket off
        fi

        if (( now >= NEXT_SYNC[$login] )); then
            run_sync "$login" --no-sync on --renew-ticket on
            NEXT_SYNC[$login]=$((SECONDS + SYNC_INTERVAL))
        fi
    done

    sleep "$CHECK_INTERVAL"
done

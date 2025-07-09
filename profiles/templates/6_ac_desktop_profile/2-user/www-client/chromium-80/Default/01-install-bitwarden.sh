# Calculate pkg(www-plugins/chrome-bitwarden)!=&&ini(user_credentials.bitwarden_login)!=&&ini(user_credentials.bitwarden_pw)!= run=/bin/bash

plugin_id="nngceckbapebfimnlniiiahkandclblb"
mkdir -p #-ur_home_path-#/.config/chromium/Default/Extensions/${plugin_id}
mkdir -p "#-ur_home_path-#/.config/chromium/Default/Local Extension Settings" &>/dev/null
cp -r /usr/share/chrome-bitwarden/* #-ur_home_path-#/.config/chromium/Default/Extensions/$plugin_id

/usr/share/chrome-bitwarden/configure.py #-ur_home_path-#/.config/chromium $plugin_id "#-ini(user_credentials.bitwarden_login)-#" "#-ini(user_credentials.bitwarden_pw)-#" "#-ini(user_credentials.bitwarden_url)-#" <<EOF
{
  "userId": {
    "keys": {
      "cryptoSymmetricKey": {}
    },
    "profile": {
      "userId": null,
      "name": null,
      "email": null
    }
  },
  "global_account_accounts": {
    "userId": {
      "name": null,
      "email": null,
      "emailVerified": true
    }
  },
  "global_account_activeAccountId": null,
  "userId_user_auto": null,
  "user_userId_autofillSettings_autofillOnPageLoad": true,
  "user_userId_userDecryptionOptions_decryptionOptions": {
    "hasMasterPassword": true
  },
  "user_userId_token_accessToken": null,
  "user_userId_token_refreshToken": null,
  "user_userId_environment_environment": {
    "region": "Self-hosted",
    "urls": {
      "base": null
    }
  },
  "user_userId_domainSettings_defaultUriMatchStrategy": 1,
  "user_userId_crypto_privateKey": null,
  "user_userId_crypto_organizationKeys": {
    "OrganizationId": {
      "type": "organization",
      "key": null
    }
  },
  "user_userId_vaultTimeoutSettings_vaultTimeout": "never"
}
EOF

chown #-ur_login-#:#-ur_group-# -R #-ur_home_path-#/.config/chromium/Default/Extensions
chown #-ur_login-#:#-ur_group-# -R "#-ur_home_path-#/.config/chromium/Default/Local Extension Settings"
exit 0

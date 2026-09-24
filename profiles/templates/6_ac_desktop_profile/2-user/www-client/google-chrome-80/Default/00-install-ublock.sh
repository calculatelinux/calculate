# Calculate pkg(www-plugins/chrome-ublock)!= run=/bin/bash

plugin_id="cjpalhdlnbpafiamejdnhcphjbkeiagm"
mkdir -p #-ur_home_path-#/.config/google-chrome/Default/Extensions/$plugin_id
mkdir -p "#-ur_home_path-#/.config/google-chrome/Default/Local Extension Settings" &>/dev/null
cp -r /usr/share/chrome-ublock/* #-ur_home_path-#/.config/google-chrome/Default/Extensions/$plugin_id

#?ini(user_credentials.ublock_whitelist)!=#
NETWHITELIST="$(sed -r 's/([^,]+)/\\"\1\\"/g' <<<"#-ini(user_credentials.ublock_whitelist)-#"),"
#!ini#
NETWHITELIST=""
#ini#

/usr/share/chrome-ublock/configure.py #-ur_home_path-#/.config/google-chrome $plugin_id &>/dev/null <<EOF
{
    "compiledMagic": "23",
    "hostnameSwitchesString": "\"no-large-media: behind-the-scene false\"",
    "netWhitelist": "[$NETWHITELIST\"about-scheme\",\"chrome-extension-scheme\",\"moz-extension-scheme\",\"opera-scheme\",\"vivaldi-scheme\",\"wyciwyg-scheme\"]",
    "selectedFilterLists": "[\"user-filters\",\"assets.json\",\"public_suffix_list.dat\",\"ublock-resources\",\"ublock-filters\",\"ublock-badware\",\"ublock-privacy\",\"ublock-abuse\",\"ublock-unbreak\",\"easylist\",\"easyprivacy\",\"malware-0\",\"malware-1\",\"plowe-0\",\"RUS-0\"]",
    "selfieMagic": "25",
    "version": "\"#-pkg(www-plugins/chrome-ublock)-#\""
}
EOF

chown #-ur_login-#:#-ur_group-# -R #-ur_home_path-#/.config/google-chrome/Default/Extensions
chown #-ur_login-#:#-ur_group-# -R "#-ur_home_path-#/.config/google-chrome/Default/Local Extension Settings"
exit 0

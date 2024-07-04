# Calculate pkg(www-plugins/chrome-floccus)!= run=/bin/bash

plugin_id="fnaicdffflnofjppbagibeoednhnbjhg"
mkdir -p #-ur_home_path-#/.config/chromium/Default/Extensions/${plugin_id}
mkdir -p "#-ur_home_path-#/.config/chromium/Default/Local Extension Settings" &>/dev/null
cp -r /usr/share/chrome-floccus/* #-ur_home_path-#/.config/chromium/Default/Extensions/$plugin_id

/usr/share/chrome-floccus/configure.py #-ur_home_path-#/.config/chromium $plugin_id &>/dev/null <<EOF
{
    "accounts": {
	"accountId": {
	    "type": "nextcloud-bookmarks",
	    "url": "#-ini(user_credentials.nextcloud_url)-#",
	    "username": "#-ini(user_credentials.nextcloud_login)-#",
	    "password": "#-ini(user_credentials.nextcloud_pw)-#",
	    "serverRoot": "",
	    "includeCredentials": false,
	    "allowRedirects": false,
	    "allowNetwork": false,
	    "enabled": true,
	    "localRoot": "1",
	    "syncInterval": 15,
	    "strategy": "default",
	    "nestedSync": true
	}
    },
    "currentVersion": "4.19.1"
}
EOF

chown #-ur_login-#:#-ur_group-# -R #-ur_home_path-#/.config/chromium/Default/Extensions
chown #-ur_login-#:#-ur_group-# -R "#-ur_home_path-#/.config/chromium/Default/Local Extension Settings"
exit 0

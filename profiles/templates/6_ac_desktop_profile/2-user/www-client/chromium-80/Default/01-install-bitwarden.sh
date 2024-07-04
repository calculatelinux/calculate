# Calculate pkg(www-plugins/chrome-bitwarden)!=&&ini(user_credentials.bitwarden_login)!=&&ini(user_credentials.bitwarden_pw)!= run=/bin/bash

plugin_id="nngceckbapebfimnlniiiahkandclblb"
mkdir -p #-ur_home_path-#/.config/chromium/Default/Extensions/${plugin_id}
mkdir -p "#-ur_home_path-#/.config/chromium/Default/Local Extension Settings" &>/dev/null
cp -r /usr/share/chrome-bitwarden/* #-ur_home_path-#/.config/chromium/Default/Extensions/$plugin_id

/usr/share/chrome-bitwarden/configure.py #-ur_home_path-#/.config/chromium $plugin_id "#-ini(user_credentials.bitwarden_login)-#" "#-ini(user_credentials.bitwarden_pw)-#" "#-ini(user_credentials.bitwarden_url)-#" &>/dev/null <<EOF
{
    "userId": {
	"data": {
	    "ciphers": {
		"encrypted": {}
	    },
	    "collections": {
		"encrypted": {}
	    },
	    "folders": {
		"encrypted": {}
	    }
	},
	"keys": {
	    "cryptoSymmetricKey": {
		"encrypted": {}
	    },
	    "organizationKeys": {
		"encrypted": {}
	    },
	    "privateKey": {
		"encrypted": {}
	    },
	    "providerKeys": {
		"encrypted": {}
	    }
	},
	"profile": {
	    "userId": {}
	},
	"settings": {
	    "avatarColor": null,
	    "defaultUriMatch": 1,
	    "enableAutoFillOnPageLoad": true,
	    "environmentUrls": {
		"api": null,
		"base": {},
		"events": null,
		"icons": null,
		"identity": null,
		"keyConnector": null,
		"notifications": null,
		"webVault": null
	    },
	    "vaultTimeout": null,
	    "vaultTimeoutAction": "lock"
	},
	"tokens": {
	    "accessToken": {},
	    "refreshToken": {}
	}
    },
    "userId_masterkey_auto": {},
    "activeUserId": {},
    "authenticatedAccounts": {},
    "global": {
	"stateVersion":7,
	"theme":"system"
    }
}
EOF

chown #-ur_login-#:#-ur_group-# -R #-ur_home_path-#/.config/chromium/Default/Extensions
chown #-ur_login-#:#-ur_group-# -R "#-ur_home_path-#/.config/chromium/Default/Local Extension Settings"
exit 0

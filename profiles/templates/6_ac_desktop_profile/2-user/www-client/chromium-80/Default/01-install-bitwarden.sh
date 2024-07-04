# Calculate pkg(www-plugins/chrome-bitwarden)!=&&ini(user_credentials.bitwarden_login)!=&&ini(user_credentials.bitwarden_pw)!= run=/bin/bash

plugin_id="nngceckbapebfimnlniiiahkandclblb"
mkdir -p #-ur_home_path-#/.config/chromium/Default/Extensions/${plugin_id}
mkdir -p "#-ur_home_path-#/.config/chromium/Default/Local Extension Settings" &>/dev/null
cp -r /usr/share/chrome-bitwarden/* #-ur_home_path-#/.config/chromium/Default/Extensions/$plugin_id

/usr/share/chrome-bitwarden/configure.py #-ur_home_path-#/.config/chromium $plugin_id "#-ini(user_credentials.bitwarden_login)-#" "#-ini(user_credentials.bitwarden_pw)-#" "#-ini(user_credentials.bitwarden_url)-#" <<EOF
{
    "userId": {
	"ciphers": {},
	"data": {
	    "ciphers": {
		"encrypted": {}
	    },
	    "passwordGenerationHistory": {},
	    "sends": {
		"encrypted": {}
	    }
	},
	"keys": {
	    "cryptoSymmetricKey": {},
	    "masterKeyEncryptedUserKey": {}
	},
	"profile": {
	    "email": "#-ini(user_credentials.bitwarden_login)-#",
	    "emailVerified": true,
	    "keyHash": {},
	    "userId": {}
	},
	"settings": {
	    "vaultTimeout": null,
	    "vaultTimeoutAction": "lock"
	},
	"tokens": {}
    },
    "userId_user_auto": {},
    "activeUserId": {},
    "authenticatedAccounts": {},
    "user_userId_autofillSettings_autofillOnPageLoad": true,
    "user_userId_autofillSettings_autofillOnPageLoadDefault": true,
    "user_userId_autofillSettings_autofillOnPageLoadPolicyToastHasDisplayed": false,
    "user_userId_crypto_organizationKeys": {
	"organizationId": {
	    "key": {},
	    "type": "organization"
	}
    },
    "user_userId_crypto_privateKey": {},
    "user_userId_domainSettings_defaultUriMatchStrategy": 1,
    "user_userId_environment_environment": {
	"urls": {
	    "base": "#-ini(user_credentials.bitwarden_url)-#"
	}
    },
    "user_userId_token_accessToken": {},
    "user_userId_token_refreshToken": {},
    "user_userId_userDecryptionOptions_decryptionOptions": {
	"hasMasterPassword": true
    }
}
EOF

chown #-ur_login-#:#-ur_group-# -R #-ur_home_path-#/.config/chromium/Default/Extensions
chown #-ur_login-#:#-ur_group-# -R "#-ur_home_path-#/.config/chromium/Default/Local Extension Settings"
exit 0

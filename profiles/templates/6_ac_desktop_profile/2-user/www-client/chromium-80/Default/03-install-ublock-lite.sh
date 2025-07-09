# Calculate pkg(www-plugins/chrome-ublock-lite)!= run=/bin/bash

plugin_id="ddkjiahejlhfcafbddmgiahcphecmpfh"
mkdir -p #-ur_home_path-#/.config/chromium/Default/Extensions/$plugin_id
mkdir -p "#-ur_home_path-#/.config/chromium/Default/Local Extension Settings" &>/dev/null
cp -r /usr/share/chrome-ublock-lite/* #-ur_home_path-#/.config/chromium/Default/Extensions/$plugin_id

/usr/share/chrome-ublock-lite/configure.py #-ur_home_path-#/.config/chromium $plugin_id <<EOF
{
  "admin_defaultFiltering": {},
  "admin_disabledFeatures": {},
  "admin_noFiltering": {},
  "admin_rulesets": {},
  "admin_showBlockedCount": {},
  "admin_strictBlockMode": {},
  "defaultRulesetIds": [
    "default",
    "badware",
    "urlhaus-full",
    "openphish-domains",
    "rus-0"
  ],
  "filteringModeDetails": {
    "basic": [],
    "complete": [
      "all-urls"
    ],
    "none": [],
    "optimal": []
  },
  "rulesetConfig": {
    "autoReload": true,
    "developerMode": false,
    "enabledRulesets": [
      "urlhaus-full",
      "rus-0"
    ],
    "hasBroadHostPermissions": true,
    "showBlockedCount": true,
    "strictBlockMode": true,
    "version": "2025.518.1611"
  }
}
EOF
chown #-ur_login-#:#-ur_group-# -R #-ur_home_path-#/.config/chromium/Default/Extensions
chown #-ur_login-#:#-ur_group-# -R "#-ur_home_path-#/.config/chromium/Default/Local Extension Settings"
exit 0


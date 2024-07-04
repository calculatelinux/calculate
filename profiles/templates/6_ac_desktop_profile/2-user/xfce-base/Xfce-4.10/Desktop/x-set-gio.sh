# Calculate exec=/bin/bash
# Adding desktop icons to trusted 
file_exec=#-ur_home_path-#/.config/autostart/gio_rules.desktop
if which gio &>/dev/null
then
	cd "#-ini(resource.desktop)-#"
	for i in *.desktop
	do
		gio_rules+="gio set -t string '#-ini(resource.desktop)-#/$i' metadata::xfce-exe-checksum $(sha256sum $i | awk '{print $1}'); "
	done
fi
gio_rules+="rm $file_exec"

echo "[Desktop Entry]
Exec=bash -c \"$gio_rules\"
Hidden=false" > $file_exec

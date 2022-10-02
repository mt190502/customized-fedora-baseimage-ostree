#!/bin/bash
#[[ ! -e /etc/modprobe.d/10-nouveau.conf ]] && echo "blacklist nouveau" | sudo tee /etc/modprobe.d/10-nouveau.conf

tee <<-'EOF' /etc/NetworkManager/conf.d/wifi.conf 1>/dev/null
[connection]
wifi.powersave = 2
EOF

echo -e 'KEYMAP="tr"\nFONT="eurlatgr"' | sudo tee /etc/vconsole.conf
systemctl enable cups NetworkManager bluetooth docker libvirtd
systemctl mask NetworkManager-wait-online

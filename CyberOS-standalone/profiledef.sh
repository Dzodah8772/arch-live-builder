#!/usr/bin/env bash
iso_name="cyberos"
iso_label="CYBEROS_$(date +%Y%m)"
iso_publisher="CyberOS"
iso_application="CyberOS Minimal Gaming"
iso_version="$(date +%Y.%m.%d)"
install_dir="arch"
buildmodes=("iso")
bootmodes=("uefi-x64.systemd-boot.eltorito")
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
declare -A file_permissions=(
  ["/root"]="0:0:750"
  ["/root/.bash_profile"]="0:0:644"
  ["/usr/local/bin/cyber-install"]="0:0:755"
  ["/usr/local/bin/cyberos-nvidia-status"]="0:0:755"
  ["/etc/skel/.xinitrc"]="0:0:644"
  ["/etc/skel/.bashrc"]="0:0:644"
)

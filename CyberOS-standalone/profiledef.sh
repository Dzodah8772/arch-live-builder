#!/usr/bin/env bash
iso_name="cyberos"
iso_label="CYBEROS_$(date +%Y%m)"
iso_publisher="CyberOS"
iso_application="CyberOS Minimal"
iso_version="$(date +%Y.%m.%d)"
install_dir="arch"
buildmodes=('iso')
bootmodes=('bios.syslinux' 'uefi.systemd-boot')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_tool_options=('-comp' 'zstd' '-Xcompression-level' '19')
declare -A file_permissions=(
  ["/root"]="0:0:750"
  ["/root/.bash_profile"]="0:0:644"
  ["/usr/local/bin/cyber-install"]="0:0:755"
  ["/etc/skel/.xinitrc"]="0:0:644"
  ["/etc/skel/.bashrc"]="0:0:644"
)
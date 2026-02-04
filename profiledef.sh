#!/usr/bin/env bash

iso_name="ArchFlux-OS"
iso_label="ARCHFLUX"
iso_publisher="ArchFlux OS"
iso_application="ArchFlux OS Live ISO"
iso_version="$(date +%Y.%m.%d)"
install_dir="arch"
bootmodes=('bios.syslinux.mbr' 'bios.syslinux.eltorito' 'uefi-ia32.systemd-boot' 'uefi-x64.systemd-boot')
arch="x86_64"
work_dir="work"
out_dir="out"
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/root"]="0:0:750"
)

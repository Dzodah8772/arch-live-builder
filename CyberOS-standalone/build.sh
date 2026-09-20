#!/bin/bash
set -e
if [[ $EUID -eq 0 ]]; then SUDO=""; else SUDO="sudo"; fi
$SUDO pacman -Sy --needed --noconfirm archiso
rm -rf work out
cp packages.x86_64 airootfs/root/packages.x86_64
$SUDO mkarchiso -v -w work -o out .
( cd out && sha256sum *.iso > SHA256SUMS )
echo "Готово: out/$(ls out | grep .iso)"

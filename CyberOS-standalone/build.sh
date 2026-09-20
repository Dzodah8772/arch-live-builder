#!/usr/bin/env bash
set -euo pipefail
if [[ $EUID -ne 0 ]]; then exec sudo "$0" "$@"; fi
pacman -Sy --needed --noconfirm archiso
rm -rf work out
mkarchiso -v -w work -o out .
(cd out && sha256sum *.iso > SHA256SUMS)
echo "ISO готов:"
ls -lh out/*.iso out/SHA256SUMS

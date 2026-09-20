#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

test -f "$ROOT/profiledef.sh"
test -f "$ROOT/pacman.conf"
test -f "$ROOT/packages.x86_64"
test -f "$ROOT/airootfs/usr/local/bin/cyber-install"

grep -q 'uefi.systemd-boot' "$ROOT/profiledef.sh"
grep -q 'bios.syslinux' "$ROOT/profiledef.sh"
grep -q '^base$' "$ROOT/packages.x86_64"
grep -q '^linux$' "$ROOT/packages.x86_64"
grep -q '^xorg-server$' "$ROOT/packages.x86_64"
grep -q '^i3-wm$' "$ROOT/packages.x86_64"
grep -q '^networkmanager$' "$ROOT/packages.x86_64"

bash -n "$ROOT/build.sh"
bash -n "$ROOT/airootfs/usr/local/bin/cyber-install"

grep -q 'wipefs -af "$DISK"' "$ROOT/airootfs/usr/local/bin/cyber-install"
grep -q 'Введите ERASE' "$ROOT/airootfs/usr/local/bin/cyber-install"
grep -q 'parted -s "$DISK" mklabel gpt' "$ROOT/airootfs/usr/local/bin/cyber-install"

echo "CyberOS profile tests: PASS"

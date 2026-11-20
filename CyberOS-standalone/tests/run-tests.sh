#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

test -f "$ROOT/profiledef.sh"
test -f "$ROOT/pacman.conf"
test -f "$ROOT/packages.x86_64"
test -f "$ROOT/airootfs/usr/local/bin/cyber-install"

# i3-wm supplies this session entry; a profile overlay would conflict during pacman install.
test ! -f "$ROOT/airootfs/usr/share/xsessions/i3.desktop"

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

# Regression checks: preserve a mounted output directory, clear its contents only,
# and verify generated ISO checksums.
grep -Fq 'find "$OUT_DIR" -mindepth 1 -maxdepth 1 -exec rm -rf -- {} +' "$ROOT/build.sh"
! grep -Eq 'rm -rf[^\n]*out' "$ROOT/build.sh"
grep -Fq 'sha256sum -c SHA256SUMS' "$ROOT/build.sh"
grep -Fq 'iso_files=' "$ROOT/build.sh"

echo "CyberOS profile tests: PASS"

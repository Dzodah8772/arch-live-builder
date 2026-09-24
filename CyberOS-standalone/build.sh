#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
: "${CYBEROS_NVIDIA:=0}"
: "${CYBEROS_CLEAN:=1}"
if [[ "$EUID" -eq 0 ]]; then SUDO=(); else SUDO=(sudo); fi
command -v mkarchiso >/dev/null 2>&1 || { echo "[ERROR] mkarchiso не найден."; exit 2; }
[[ "$CYBEROS_CLEAN" == "1" ]] && rm -rf work out
mkdir -p out airootfs/root
cp packages.x86_64 /tmp/cyberos-packages.x86_64
trap 'cp /tmp/cyberos-packages.x86_64 packages.x86_64' EXIT
case "$CYBEROS_NVIDIA" in
  1|true|TRUE|yes|YES) cat packages.nvidia.x86_64 >> packages.x86_64; echo "[INFO] NVIDIA profile enabled." ;;
  *) echo "[INFO] Base ISO without NVIDIA driver packages." ;;
esac
cp packages.x86_64 airootfs/root/packages.x86_64
"${SUDO[@]}" mkarchiso -v -r -w work -o out .
shopt -s nullglob
isos=(out/*.iso)
(( ${#isos[@]} )) || { echo "[ERROR] mkarchiso не создал ISO."; exit 3; }
sha256sum "${isos[@]}" > out/SHA256SUMS
printf '\nISO готов:\n'
printf '  %s\n' "${isos[@]}"

#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    exec sudo "$0" "$@"
fi

PROFILE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
WORK_DIR="$PROFILE_DIR/work"
OUT_DIR="$PROFILE_DIR/out"

cd "$PROFILE_DIR"

pacman -Sy --needed --noconfirm archiso

# work is disposable build state. Guard against symlinks before removing it.
if [[ -L "$WORK_DIR" ]]; then
    echo "Ошибка: work не должен быть символической ссылкой." >&2
    exit 1
fi
rm -rf -- "$WORK_DIR"
mkdir -p -- "$WORK_DIR"

# out may be a Docker bind mount. Keep the directory itself and clear only
# its contents so the mounted path remains available to the container.
if [[ -L "$OUT_DIR" ]]; then
    echo "Ошибка: out не должен быть символической ссылкой." >&2
    exit 1
fi
mkdir -p -- "$OUT_DIR"
find "$OUT_DIR" -mindepth 1 -maxdepth 1 -exec rm -rf -- {} +

mkarchiso -v -w "$WORK_DIR" -o "$OUT_DIR" "$PROFILE_DIR"

shopt -s nullglob
iso_files=( "$OUT_DIR"/*.iso )
if (( ${#iso_files[@]} == 0 )); then
    echo "Ошибка: mkarchiso завершился без создания ISO." >&2
    exit 1
fi

# Generate and immediately verify checksums using filenames relative to out.
(
    cd "$OUT_DIR"
    sha256sum -- *.iso > SHA256SUMS
    sha256sum -c SHA256SUMS
)

echo "ISO готов:"
ls -lh -- "${iso_files[@]}" "$OUT_DIR/SHA256SUMS"

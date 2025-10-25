#!/usr/bin/env bash
set -euo pipefail

# Скрипт: build.sh
# Требования: запустите на Arch Linux или в контейнере с pacman (root/возможность sudo).
# Устанавливает archiso при необходимости, создаёт профиль ArchFlux и собирает ISO.

PROFILE_NAME="archflux"
WORKDIR="$PWD/work"
OUTDIR="$PWD/out"
SRCTEMPLATE="/usr/share/archiso/configs/releng"

if ! command -v mkarchiso >/dev/null 2>&1; then
  echo "archiso не найден. Устанавливаю..."
  sudo pacman -S --needed archiso
fi

# Подготовка рабочей копии профиля
rm -rf "$PROFILE_NAME" "$WORKDIR" "$OUTDIR"
cp -r "$SRCTEMPLATE" "$PROFILE_NAME"

# Подменяем packages.x86_64 на наш
cp packages.x86_64 "$PROFILE_NAME"/packages.x86_64

# Копируем airootfs overlay (директория с конфигами для live-окружения)
rm -rf "$PROFILE_NAME"/airootfs
cp -r airootfs "$PROFILE_NAME"/airootfs

# Опционально: добавьте свои файлы в isolinux/efi, загрузочные скрипты и др.

echo "Запускаю сборку ISO (mkarchiso)..."
sudo mkarchiso -v -w "$WORKDIR" -o "$OUTDIR" "$PROFILE_NAME"

echo "Готово. Результат в: $OUTDIR"

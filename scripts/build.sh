#!/usr/bin/env bash
set -euo pipefail

# Скрипт: build.sh
# Требования: запуск на Arch Linux или в контейнере с pacman.
# Устанавливает archiso при необходимости, создаёт профиль ArchFlux и собирает ISO.

PROFILE_NAME="${PROFILE_NAME:-archflux}"
WORKDIR="${WORKDIR:-$PWD/work}"
OUTDIR="${OUTDIR:-$PWD/out}"
SRCTEMPLATE="${SRCTEMPLATE:-/usr/share/archiso/configs/releng}"

if [[ "${EUID:-$(id -u)}" -eq 0 ]]; then
  SUDO=""
else
  SUDO="sudo"
fi

if ! command -v mkarchiso >/dev/null 2>&1; then
  echo "archiso не найден. Устанавливаю..."
  $SUDO pacman -S --needed --noconfirm archiso
fi

# Подготовка рабочей копии профиля
rm -rf "$PROFILE_NAME" "$WORKDIR" "$OUTDIR"
cp -r "$SRCTEMPLATE" "$PROFILE_NAME"

# Подменяем packages.x86_64 на наш (если существует)
if [[ -f "packages.x86_64" ]]; then
  cp packages.x86_64 "$PROFILE_NAME"/packages.x86_64
fi

# Подменяем profiledef.sh (если существует)
if [[ -f "profiledef.sh" ]]; then
  cp profiledef.sh "$PROFILE_NAME"/profiledef.sh
fi

# Копируем airootfs overlay (директория с конфигами для live-окружения)
if [[ -d "airootfs" ]]; then
  rm -rf "$PROFILE_NAME"/airootfs
  cp -r airootfs "$PROFILE_NAME"/airootfs
fi

# Копируем загрузчики (isolinux/efiboot), если заданы
if [[ -d "boot/isolinux" ]]; then
  rm -rf "$PROFILE_NAME"/isolinux
  cp -r boot/isolinux "$PROFILE_NAME"/isolinux
fi

if [[ -d "boot/efiboot" ]]; then
  rm -rf "$PROFILE_NAME"/efiboot
  cp -r boot/efiboot "$PROFILE_NAME"/efiboot
fi

# Опционально: добавьте свои файлы в isolinux/efi, загрузочные скрипты и др.

echo "Запускаю сборку ISO (mkarchiso)..."
$SUDO mkarchiso -v -w "$WORKDIR" -o "$OUTDIR" "$PROFILE_NAME"

echo "Готово. Результат в: $OUTDIR"

#!/usr/bin/env bash
set -euo pipefail

# Скрипт: build.sh
# Требования: запуск на Arch Linux или в контейнере с pacman.
# Устанавливает archiso при необходимости, создаёт профиль ArchFlux и собирает ISO.

PROFILE_NAME="${PROFILE_NAME:-archflux}"
WORKDIR="${WORKDIR:-$PWD/work}"
OUTDIR="${OUTDIR:-$PWD/out}"
SRCTEMPLATE="${SRCTEMPLATE:-/usr/share/archiso/configs/releng}"
KEEP_WORKDIR="${KEEP_WORKDIR:-0}"

if [[ "${EUID:-$(id -u)}" -eq 0 ]]; then
  SUDO=""
else
  SUDO="sudo"
fi

usage() {
  cat <<USAGE
Usage: ./scripts/build.sh [options]

Options:
  --keep-workdir       Не очищать profile/work/out перед сборкой.
  --profile-name NAME  Имя временного профиля (default: archflux).
  --workdir PATH       Каталог рабочей директории mkarchiso.
  --outdir PATH        Каталог для готового ISO.
  --template PATH      Путь к шаблону archiso (releng).
  -h, --help           Показать справку.

Также можно использовать переменные окружения:
  PROFILE_NAME, WORKDIR, OUTDIR, SRCTEMPLATE, KEEP_WORKDIR
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --keep-workdir)
      KEEP_WORKDIR=1
      shift
      ;;
    --profile-name)
      PROFILE_NAME="$2"
      shift 2
      ;;
    --workdir)
      WORKDIR="$2"
      shift 2
      ;;
    --outdir)
      OUTDIR="$2"
      shift 2
      ;;
    --template)
      SRCTEMPLATE="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Неизвестный аргумент: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if ! command -v pacman >/dev/null 2>&1; then
  echo "Ошибка: pacman не найден. Запустите скрипт в Arch Linux/контейнере Arch." >&2
  exit 1
fi

if [[ ! -d "$SRCTEMPLATE" ]]; then
  echo "Ошибка: шаблон archiso не найден: $SRCTEMPLATE" >&2
  exit 1
fi

if ! command -v mkarchiso >/dev/null 2>&1; then
  echo "archiso не найден. Устанавливаю..."
  $SUDO pacman -S --needed --noconfirm archiso
fi

# Подготовка рабочей копии профиля
if [[ "$KEEP_WORKDIR" != "1" ]]; then
  rm -rf "$PROFILE_NAME" "$WORKDIR" "$OUTDIR"
fi

cp -r "$SRCTEMPLATE" "$PROFILE_NAME"

# Подменяем packages.x86_64 на наш (если существует)
if [[ -f "packages.x86_64" ]]; then
  cp packages.x86_64 "$PROFILE_NAME"/packages.x86_64
fi

# Копируем airootfs overlay (директория с конфигами для live-окружения)
if [[ -d "airootfs" ]]; then
  rm -rf "$PROFILE_NAME"/airootfs
  cp -r airootfs "$PROFILE_NAME"/airootfs
fi

echo "Запускаю сборку ISO (mkarchiso)..."
$SUDO mkarchiso -v -w "$WORKDIR" -o "$OUTDIR" "$PROFILE_NAME"

latest_iso="$(find "$OUTDIR" -maxdepth 1 -type f -name '*.iso' | sort | tail -n 1 || true)"
if [[ -n "$latest_iso" ]]; then
  echo "Готово. ISO: $latest_iso"
else
  echo "Готово. Результат в: $OUTDIR"
fi

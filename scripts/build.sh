#!/usr/bin/env bash
set -euo pipefail

# Скрипт сборки ArchFlux ISO на базе archiso releng

PROFILE_NAME="${PROFILE_NAME:-archflux}"
WORKDIR="${WORKDIR:-$PWD/work}"
OUTDIR="${OUTDIR:-$PWD/out}"
SRCTEMPLATE="${SRCTEMPLATE:-/usr/share/archiso/configs/releng}"
CLEAN_BEFORE_BUILD="${CLEAN_BEFORE_BUILD:-1}"

log() {
  printf '[archflux-build] %s\n' "$*"
}

fail() {
  printf '[archflux-build] ERROR: %s\n' "$*" >&2
  exit 1
}

if [[ "${EUID:-$(id -u)}" -eq 0 ]]; then
  SUDO=""
else
  SUDO="sudo"
fi

command -v cp >/dev/null 2>&1 || fail "cp не найден"
command -v rm >/dev/null 2>&1 || fail "rm не найден"

if ! command -v mkarchiso >/dev/null 2>&1; then
  log "archiso не найден. Устанавливаю..."
  $SUDO pacman -S --needed --noconfirm archiso
fi

[[ -d "$SRCTEMPLATE" ]] || fail "Не найден шаблон archiso: $SRCTEMPLATE"

if [[ "$CLEAN_BEFORE_BUILD" == "1" ]]; then
  log "Очищаю предыдущие артефакты"
  rm -rf "$PROFILE_NAME" "$WORKDIR" "$OUTDIR"
fi

log "Готовлю профиль '$PROFILE_NAME' из шаблона '$SRCTEMPLATE'"
cp -r "$SRCTEMPLATE" "$PROFILE_NAME"

if [[ -f "packages.x86_64" ]]; then
  log "Применяю кастомный список пакетов"
  cp packages.x86_64 "$PROFILE_NAME/packages.x86_64"
fi

if [[ -d "airootfs" ]]; then
  log "Применяю overlay airootfs"
  rm -rf "$PROFILE_NAME/airootfs"
  cp -r airootfs "$PROFILE_NAME/airootfs"
fi

if [[ -f "$PROFILE_NAME/packages.x86_64" ]]; then
  log "Пакетов в профиле: $(wc -l < "$PROFILE_NAME/packages.x86_64")"
fi

log "Запускаю mkarchiso"
$SUDO mkarchiso -v -w "$WORKDIR" -o "$OUTDIR" "$PROFILE_NAME"

LATEST_ISO="$(find "$OUTDIR" -maxdepth 1 -type f -name '*.iso' | sort | tail -n1 || true)"
if [[ -n "$LATEST_ISO" ]]; then
  log "ISO успешно собрано: $LATEST_ISO"
else
  log "Сборка завершена, но ISO не найдено в $OUTDIR"
fi

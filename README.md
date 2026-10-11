# ArchFlux OS — сборка live-ISO

Этот репозиторий содержит базовую инфраструктуру для сборки Arch-based live ISO (ArchFlux OS) через `archiso`.

## Что уже есть

- `scripts/build.sh` — основной сценарий сборки ISO (локально, в контейнере и в CI).
- `packages.x86_64` — минимальный список пакетов для live-среды.
- `airootfs/` — overlay-файлы, которые попадут в live-окружение.
- `scripts/archflux-run.ps1` — PowerShell-скрипт для Windows: сборка + запуск VM в VirtualBox.
- `.github/workflows/build-iso.yml` — пример CI workflow для автоматической сборки ISO.

## Быстрый старт (локально)

1. Убедитесь, что вы на Arch Linux (или в среде с `pacman`).
2. Запустите скрипт сборки:

```bash
./scripts/build.sh
```

Скрипт автоматически установит `archiso` при необходимости и соберёт ISO в директорию `out/`.

### Полезные переменные окружения

- `PROFILE_NAME` — имя временного профиля (по умолчанию `archflux`).
- `WORKDIR` — рабочий каталог `mkarchiso` (по умолчанию `./work`).
- `OUTDIR` — каталог с результатом (по умолчанию `./out`).
- `SRCTEMPLATE` — шаблон профиля (`/usr/share/archiso/configs/releng`).
- `CLEAN_BEFORE_BUILD=0` — не удалять предыдущие артефакты перед сборкой.

Пример:

```bash
OUTDIR=$PWD/out PROFILE_NAME=archflux-dev ./scripts/build.sh
```

## Сборка в Docker

```bash
docker build -t archflux-builder .
docker run --rm -v "$(pwd)":/workspace archflux-builder
```

## CI-сборка (GitHub Actions)

Workflow `.github/workflows/build-iso.yml` запускает сборку на `push`, `pull_request` и вручную (`workflow_dispatch`) и публикует ISO как артефакт.

## Полезные материалы

План развития и дорожная карта находятся в каталоге [`projects/`](projects/).

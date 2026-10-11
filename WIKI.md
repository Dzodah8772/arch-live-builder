# Вики репозитория ArchFlux OS (arch-live-builder)

## Назначение

Этот репозиторий — шаблон для сборки Arch-based live ISO (ArchFlux OS) на базе `archiso`. Основной сценарий: подготовить профиль `archiso`, наложить overlay из `airootfs`, применить список пакетов и собрать готовый ISO. 【F:README.md†L1-L27】【F:scripts/build.sh†L1-L49】

## Структура репозитория

- `README.md` — краткое описание, инструкции по сборке и базовая настройка. 【F:README.md†L1-L27】
- `scripts/build.sh` — основной скрипт сборки ISO на Arch Linux или в контейнере. 【F:scripts/build.sh†L1-L49】
- `packages.x86_64` — список пакетов, устанавливаемых в live-окружении. 【F:packages.x86_64†L1-L15】
- `airootfs/` — overlay директории, попадающий в live-окружение (например, настройки в `/etc`). 【F:README.md†L24-L26】
- `projects/` — материалы по этапам работ и планированию. 【F:README.md†L28-L28】
- `код` — PowerShell-скрипт для обновления репозитория, сборки ISO и запуска VM в VirtualBox. 【F:код†L1-L40】

## Сборка ISO локально (Arch Linux)

1. Убедитесь, что работаете на Arch Linux (или в окружении с `pacman`). 【F:README.md†L7-L13】
2. Запустите сборку:

```bash
./scripts/build.sh
```

Скрипт при необходимости установит `archiso`, скопирует профиль `releng`, применит `packages.x86_64` и `airootfs`, а затем соберёт ISO в каталог `out/`. 【F:scripts/build.sh†L1-L49】

## Сборка ISO в Docker

Сборка в контейнере обеспечивает более воспроизводимое окружение.

```bash
docker build -t archflux-builder .
```

```bash
docker run --rm -v "$(pwd)":/workspace archflux-builder
```

Контейнер использует `archiso`, поэтому ему потребуется доступ к зеркалам `pacman`. 【F:README.md†L15-L22】

## Настройка состава live-ISO

### Список пакетов

Редактируйте `packages.x86_64`, чтобы изменить набор пакетов live-окружения. Файл содержит базовые пакеты (например, `base`, `linux`, `systemd`, `networkmanager`, редакторы). 【F:packages.x86_64†L1-L15】

### Overlay файловой системы

Добавляйте или изменяйте файлы в `airootfs/`, чтобы они попадали в live-среду. Пример: `airootfs/etc/hostname`. 【F:README.md†L24-L26】

## Скрипт сборки (`scripts/build.sh`)

Ключевая логика сборки:

- определяет рабочие каталоги (`work/`, `out/`), имя профиля и базовый шаблон `archiso` (`/usr/share/archiso/configs/releng`);
- при необходимости устанавливает пакет `archiso` через `pacman`;
- копирует шаблон профиля, заменяет `packages.x86_64` и `airootfs`;
- запускает `mkarchiso` для сборки ISO. 【F:scripts/build.sh†L1-L49】

Эти переменные можно переопределить через окружение:

- `PROFILE_NAME` — имя создаваемого профиля;
- `WORKDIR` — рабочая директория сборки;
- `OUTDIR` — выходная директория с ISO;
- `SRCTEMPLATE` — базовый шаблон профиля `archiso`. 【F:scripts/build.sh†L8-L15】

## PowerShell-скрипт для Windows (`код`)

Файл `код` содержит PowerShell-скрипт `archflux-run.ps1` для пользователей Windows. Он проверяет наличие `git`, `VBoxManage`, `bash`/`wsl`, обновляет репозиторий и готовит запуск сборки/VM. Это удобно для локального CI-подобного цикла с VirtualBox. 【F:код†L1-L40】

## Материалы проекта

В каталоге `projects/` лежит серия Markdown-документов по этапам/плану работ (например, базовая система, сборка ISO, виртуализация и будущие планы). Полный список — в `projects/README.md`. 【F:README.md†L28-L28】【F:projects/README.md†L1-L20】

---

Если нужно расширить вики (например, добавить раздел по настройке `isolinux`/`efi`, CI или пакеты по профилям), дайте знать — добавлю соответствующие страницы.

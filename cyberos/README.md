# CyberOS Minimal

Минимальный Arch-based установщик: i3 + Alacritty + NetworkManager + Btrfs + systemd-boot.

## Сборка

На Arch Linux:

```sh
sudo pacman -S archiso
cd cyberos
./build.sh
```

ISO появится в `out/`.

## VirtualBox

Включите EFI в настройках виртуальной машины. Рекомендуется 2 ГБ RAM и диск от 20 ГБ.

## Установка

Установщик показывает диски, требует подтверждение `ERASE`, спрашивает часовой пояс, имя пользователя и пароль. Выбранный диск полностью стирается. Создаются GPT, EFI и Btrfs с субтомами `@` и `@home`.

После установки запускаются NetworkManager и i3; загрузчик — systemd-boot.

**Сначала тестируйте в VirtualBox. Уничтожение выбранного диска необратимо.**

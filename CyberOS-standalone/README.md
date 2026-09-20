# CyberOS Minimal Standalone

Arch Linux based CyberOS ISO profile with i3, LightDM, Firefox, Thunar, Btrfs, systemd-boot and a custom installer.

## Build

Requires Arch Linux or an Arch Linux container with network access:

```sh
sudo pacman -S archiso
./build.sh
```

The ISO is written to `out/` and a `SHA256SUMS` file is generated.

## VirtualBox

Enable **EFI** in the VM firmware settings. Allocate at least 2 CPU cores, 4 GiB RAM and 20 GiB disk for a comfortable test.

## Installer

`cyber-install` supports:
- UEFI-only installation
- whole-disk installation
- alongside-existing-OS installation using free space
- Btrfs `@` and `@home`
- optional LUKS2 encryption
- systemd-boot
- NetworkManager/iwd
- microcode, zram, TRIM and snapshots
- optional Secure Boot setup when firmware is in Setup Mode

The installer can erase a selected disk in whole-disk mode. Back up important data and test in a VM first.

## Tests

```sh
bash tests/run-tests.sh
```

These are logic/safety tests and do not replace a real VirtualBox boot test.

## License

MIT.

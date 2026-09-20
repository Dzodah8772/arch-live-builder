# CyberOS Minimal Standalone

Arch Linux based CyberOS ISO profile for VirtualBox and UEFI/BIOS PCs.

## Included
- Arch Linux base, i3, LightDM, Alacritty
- Firefox, Thunar
- NetworkManager + iwd
- PipeWire audio
- Btrfs tools, zram and related utilities
- systemd-boot for UEFI and Syslinux for BIOS
- custom `cyber-install` installer
- Btrfs `@` and `@home` subvolumes in whole-disk install mode

LUKS, snapshots and Secure Boot packages are present for future expansion; the current installer does not configure them automatically.

## Build on Arch
```bash
sudo pacman -S --needed archiso
cd CyberOS-standalone
./build.sh
```

## Build with Docker
From repository root:
```bash
docker run --rm --privileged -v "$PWD/CyberOS-standalone:/src" -w /src archlinux:latest ./build.sh
```

The ISO and SHA256SUMS are written to `out/`.

## VirtualBox
Recommended: 2-4 CPU cores, 4 GiB RAM, 20 GiB disk, 128 MiB video memory, NAT networking.
For UEFI testing enable **EFI**. BIOS boot is also included.

Boot the ISO and run:
```bash
cyber-install
```
The current installer is whole-disk and destructive. It creates GPT, an EFI partition and Btrfs root with `@` and `@home`. Test in a disposable VM first.

## CI
`.github/workflows/cyberos-iso.yml` validates the profile and builds/uploads the ISO as a GitHub Actions artifact.

## Validation
```bash
bash tests/run-tests.sh
```
These are profile/safety checks; a real VirtualBox boot test is still required.

## License
MIT.

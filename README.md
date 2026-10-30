# CyberOS

CyberOS is an Arch Linux-based live ISO project focused on a reproducible build, a practical desktop environment, and a transparent installer workflow. The maintained standalone profile currently lives in `CyberOS-standalone/`.

> **Project status:** experimental. Builds and profile checks are automated, but every ISO release still requires a real boot test in VirtualBox or on spare hardware before it should be considered usable.

## Current profile

The standalone profile currently includes:

- Arch Linux x86_64 and the i3 desktop
- LightDM and Alacritty
- Firefox and Thunar
- NetworkManager and iwd
- PipeWire audio
- Btrfs utilities and zram-related packages
- UEFI boot via systemd-boot and legacy BIOS boot via Syslinux
- A custom `cyber-install` installer

See [CyberOS-standalone/README.md](CyberOS-standalone/README.md) for the exact profile and build instructions. Features described as future work are not represented as implemented.

## Build

On Arch Linux:

```bash
sudo pacman -S --needed archiso
cd CyberOS-standalone
sudo ./build.sh
```

The ISO and `SHA256SUMS` are written to `CyberOS-standalone/out/`.

The repository also contains a Docker-based build path. From the repository root:

```bash
docker build --pull -t cyberos-builder .
docker run --rm --privileged \
  -v "$PWD/CyberOS-standalone/out:/workspace/out" \
  cyberos-builder
```

## Validate before building

```bash
bash CyberOS-standalone/tests/run-tests.sh
```

These checks validate profile files and shell syntax. They do **not** replace boot testing. See [docs/TESTING.md](docs/TESTING.md).

## Safety warning

The current `cyber-install` workflow is destructive in whole-disk mode: it repartitions the selected disk and erases existing data. Test only in a disposable virtual machine unless you have independently verified the target disk and backed up all important data. Never run the installer against a disk containing data you need to keep.

## Contributing

Bug reports, reproducible test results, documentation improvements, and reviewed code contributions are welcome. Read [CONTRIBUTING.md](CONTRIBUTING.md), [SECURITY.md](SECURITY.md), and the [Code of Conduct](CODE_OF_CONDUCT.md) before participating.

## Roadmap

See [docs/ROADMAP.md](docs/ROADMAP.md) for planned work. Roadmap items are proposals until implemented and tested.

## License

MIT. See [LICENSE](LICENSE).

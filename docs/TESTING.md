# Testing CyberOS

## 1. Static profile checks

Run from the repository root:

```bash
bash CyberOS-standalone/tests/run-tests.sh
```

The current script checks required profile files, selected packages, boot modes, shell syntax, and installer confirmation/partitioning markers.

## 2. Build test

On Arch Linux:

```bash
sudo pacman -S --needed archiso
cd CyberOS-standalone
sudo ./build.sh
```

Or use the Docker workflow documented in the root README. Confirm that an ISO and `SHA256SUMS` are produced.

## 3. VirtualBox smoke test

Use a disposable VM. Suggested starting configuration:

- 2–4 virtual CPUs;
- 4 GiB RAM;
- 20 GiB virtual disk;
- NAT networking;
- 128 MiB video memory;
- test UEFI with EFI enabled, then test legacy BIOS separately.

Verify that the ISO boots, the live environment reaches its login/desktop, networking can be enabled, and basic applications start.

## 4. Installer test — destructive

The current installer is whole-disk and destructive. Use only a newly created disposable virtual disk attached to a throwaway VM. Confirm the target disk shown by the installer before entering its explicit confirmation phrase. Verify the resulting partition table and filesystem after installation.

Never use a physical disk containing valuable data for installer testing.

## 5. Report results

For each test report, include:

- commit SHA and ISO filename;
- host OS and VirtualBox version;
- guest firmware mode (UEFI or BIOS);
- VM CPU/RAM/disk settings;
- exact steps and result;
- relevant logs or screenshots with secrets removed;
- known failures and tests not performed.

A passing static test is not evidence that the ISO boots successfully.

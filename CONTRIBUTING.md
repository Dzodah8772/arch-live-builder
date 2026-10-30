# Contributing to CyberOS

Thank you for considering a contribution.

## Before opening a change

1. Read the root README and [CyberOS-standalone/README.md](CyberOS-standalone/README.md).
2. Check existing issues and pull requests to avoid duplicate work.
3. For significant changes, open an issue first and describe the problem, proposed design, risks, and test plan.
4. Keep changes focused. Do not mix unrelated refactors with functional changes.

## Development workflow

1. Fork the repository and create a topic branch.
2. Make the smallest complete change.
3. Run the profile checks:

   ```bash
   bash CyberOS-standalone/tests/run-tests.sh
   ```

4. For shell changes, run `bash -n path/to/script` on every modified Bash script.
5. If the change affects the ISO, build it using the documented Arch/Docker workflow.
6. Boot-test the resulting ISO in a disposable VirtualBox VM. Include VM firmware mode, RAM, CPU count, and observed result in the PR.
7. Update relevant documentation and clearly state anything not tested.

## Pull request checklist

- [ ] The change addresses one clearly described problem.
- [ ] No credentials, private keys, personal data, or generated ISO files are committed.
- [ ] Shell syntax/profile checks pass.
- [ ] Destructive disk operations are documented and guarded.
- [ ] Documentation reflects actual behavior, not intended future behavior.
- [ ] Testing performed and limitations are stated.

## Safety requirements

Installer and disk-management changes require special care. Never remove confirmation gates, silently select a disk, or claim that an operation preserves data unless this is demonstrated by tests. Do not test destructive operations on a disk containing valuable data.

## Commit messages

Use short imperative messages, for example:

- `docs: clarify VirtualBox boot test procedure`
- `fix(installer): validate target disk before partitioning`
- `test(profile): check required bootloader packages`

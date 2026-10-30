# CyberOS roadmap

This roadmap records intentions, not promises. A task is complete only after its implementation is merged and the relevant tests or manual validation are documented.

## Current baseline

- [x] Archiso-based standalone profile exists.
- [x] Docker build container exists.
- [x] Profile/shell validation script exists.
- [x] GitHub Actions workflow validates and builds the ISO.
- [ ] Publish a repeatable VirtualBox test report for each release.
- [ ] Document the exact installer flow and disk layout with screenshots or terminal captures.

## Near-term priorities

### P0 — Safety and reproducibility

- [ ] Add non-destructive installer preflight checks and explicit target-disk display.
- [ ] Add tests for installer confirmation gates and failure paths.
- [ ] Pin or record build inputs and package versions for reproducibility.
- [ ] Verify ISO checksum generation and artifact naming in CI.
- [ ] Test UEFI and BIOS boot in disposable VirtualBox machines.

### P1 — Usability

- [ ] Document first boot, networking, desktop login, and troubleshooting.
- [ ] Document supported hardware assumptions and known limitations.
- [ ] Add a release checklist and versioned release notes.
- [ ] Improve accessibility and localization of installer messages.

### P2 — Community and ecosystem

- [ ] Add issue templates and contribution guidance.
- [ ] Publish a transparent support matrix.
- [ ] Welcome independent testers and review external contributions.
- [ ] Track real adoption using public releases and verifiable project activity.

## Non-goals

- Artificial stars, fabricated users, or manufactured contribution activity.
- Claims of production readiness without repeatable testing.
- Silent disk formatting or data-preservation guarantees that have not been proven.

# Claude for Open Source — readiness notes

This document is a project-planning aid. It does not claim that CyberOS currently qualifies for Anthropic's program or that an application will be approved.

## Official offer

Anthropic currently advertises six months of Claude Max 20x for approved open-source maintainers and contributors. Review the official program page and terms immediately before applying because eligibility and availability can change:

- https://claude.com/contact-sales/claude-for-oss

The current public criteria include one or more of the following paths:

- maintaining packages with at least 500 dependent repositories, 100 dependent packages, or 200,000 combined monthly downloads;
- being a listed committer/maintainer on a recognized foundation or language project;
- authoring at least 100 pull requests merged into repositories you do not own in the previous 12 months;
- maintaining a repository with at least 20 unique external contributors whose pull requests were merged in the previous 12 months;
- maintaining critical infrastructure meeting the stated OpenSSF criticality threshold.

Anthropic says projects with ecosystem impact that do not fit a listed threshold may still apply at its discretion. Meeting a threshold does not guarantee approval.

## Current CyberOS position

CyberOS is an experimental project. At the time this document was added, this repository does not have evidence in this checkout of the scale required by the listed quantitative criteria. Creating documentation, a release, or a repository does not itself establish eligibility.

## Ethical readiness plan

1. Keep the project public and use an OSI-approved license.
2. Ship useful, tested improvements with release notes.
3. Invite independent users to test the ISO and report reproducible issues.
4. Review external contributions on their technical merits; merge only useful, reviewed changes.
5. Maintain a public record of releases, test results, issue triage, and contributor acknowledgements.
6. Do not buy stars, fabricate downloads, create sockpuppet accounts, or submit trivial/duplicative pull requests.
7. Apply only when the project has real evidence of impact, or when there is a truthful, compelling ecosystem-impact case.

## Evidence to collect

- public release URLs and dates;
- verified download counts, where available;
- merged external pull requests and unique contributor identities;
- dependency/adoption evidence, if applicable;
- reproducible build and boot-test reports;
- concrete examples of who depends on the project and what problem it solves.

Never include private user data or secrets in an application.

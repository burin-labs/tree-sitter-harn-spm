# Repository settings proposal

This file **proposes** changes to GitHub repository settings. It does not apply
them. Repository and organization settings are the founder's to change, so
treat every item below as a recommendation waiting on a decision.

Written during the org-wide repository hygiene sweep on 2026-09-01.

## What this repository is

`tree-sitter-harn-spm` vendors the generated parser for the Harn tree-sitter
grammar so Swift Package Manager can build it. It differs from the wrappers
around third-party grammars in one way that matters for these settings: the
upstream grammar is this organization's own, so a stale parser here is a defect
this organization owns end to end rather than something to forward elsewhere.

Every commit is from a single maintainer or from Dependabot. There are no
stars, forks, or external pull requests. The repository is public so Swift
Package Manager can resolve it and so hosted CI runs without a paid plan, not
because it invites collaboration.

The issue tracker is genuinely used. Issue #11 records that the vendored parser
is eleven commits behind the canonical grammar and includes a breaking change,
and issue #12 recorded the missing test target that pull request #16 then
closed. That is real tracked engineering, and it is the reason the issue
recommendation below differs from the other grammar wrappers.

## Proposed changes

| Setting | Today | Proposed | Why |
| --- | --- | --- | --- |
| Issues | Enabled | **Keep enabled, and do not revisit** | The tracker holds live, substantive work. Disabling it would discard the record of a known parser defect. |
| Discussions | Disabled | Keep disabled | Design conversation about the grammar belongs in `burin-labs/harn`, next to the grammar. |
| Wiki | Check and disable if enabled | Disabled | `README.md`, `CONTRIBUTING.md`, and `UPSTREAM.md` are the documentation. A wiki is a second place for the same facts to drift. |
| Projects | Check and disable if enabled | Disabled | Planning happens in the consuming repository, not here. |
| Pull requests from non-members | Allowed | **Restrict to organization members** | A drive-by pull request against a multi-megabyte generated `parser.c` is a supply-chain risk that review cannot cheaply catch. |
| Branch protection on `main` | Verify | Require the CI status check and a pull request | Prevents an accidental direct push to the branch consumers resolve from. |
| Merge strategy | Verify | Squash only, delete branch on merge | Keeps history one commit per change, matching the rest of the org. |

## Deliberately not proposed

- **Archiving.** The package is a live dependency of a consuming Swift project,
  and it has an open defect. Archiving would be wrong on both counts.
- **Making it private.** Swift Package Manager consumers resolve it over HTTPS.
  Private would break that path without a token.

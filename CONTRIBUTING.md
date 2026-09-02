# Contributing to `tree-sitter-harn-spm`

## Scope

This repository is a packaging wrapper. It vendors the generated parser for the
Harn tree-sitter grammar so Swift Package Manager can build it without running
`tree-sitter-cli`. The grammar itself is not developed here.

Unlike the wrappers around third-party grammars, the upstream in this case is
this organization's own: the canonical grammar lives in
[`burin-labs/harn`](https://github.com/burin-labs/harn/tree/main/tree-sitter-harn).
A grammar change belongs in that repository, and this wrapper follows it.

**External feature contributions are not accepted here.** What is in scope, and
worth an issue on this repository, is anything that makes the wrapper wrong
against the grammar it claims to vendor: a parser that has fallen behind the
canonical grammar, a build that fails, a missing exported symbol, or a
`Package.swift` source list that does not match the vendored files. The issue
tracker is actively used for exactly that, so read the open issues before you
file. Report a security problem through
[`.github/SECURITY.md`](.github/SECURITY.md) rather than a public issue.

This repo is a thin **Swift Package Manager wrapper** around the
[`tree-sitter-harn`](https://github.com/burin-labs/harn/tree/main/tree-sitter-harn) tree-sitter grammar. The generated parser
(`Sources/TreeSitterHarn/src/parser.c` and any `scanner.c`) is **vendored** so
SPM can build it without `tree-sitter-cli`. The canonical grammar lives **in the harn repo** (`tree-sitter-harn/`), not upstream on GitHub — re-vendor from your local harn checkout.

There is almost nothing to "develop" here — the value is in keeping the
vendored parser honest, building cleanly, and being safe to depend on.

## Prerequisites

- Swift 6.0+ toolchain (`swift --version`)

## Build & verify

```sh
swift build
```

To confirm the parser entry point is actually exported:

```sh
nm "$(find .build -name parser.c.o | head -1)" | grep ' T _tree_sitter_'
```

You should see `T _tree_sitter_harn`. If the grammar ships an
external scanner, `scanner.c.o` must also export the five
`*_external_scanner_*` symbols, and `scanner.c` must be listed in
`Package.swift`'s `sources`.

## Updating the grammar (re-vendoring)

This is the main reason to touch this repo. **Read [UPSTREAM.md](UPSTREAM.md)** —
it documents the exact upstream source, the last reviewed commit, and the
step-by-step re-vendor procedure. In short:

1. Clone the upstream grammar and capture `git rev-parse HEAD`.
2. Copy `src/parser.c`, `src/scanner.c` (if present), and `src/tree_sitter/*.h`
   into `Sources/TreeSitterHarn/src/`.
3. If the grammar gained/lost an external scanner, update the `sources` list
   in `Package.swift` to match.
4. Update **Last reviewed commit** and the date in `UPSTREAM.md`.
5. `swift build` and run the symbol check above.

### Supply-chain rules (non-negotiable)

- A multi-hundred-KB `parser.c` **is** the supply chain. Review the diff. If
  you can't justify a chunk, don't commit it.
- Never bump the vendored parser without recording the exact source SHA in
  `UPSTREAM.md`. Reviewers rely on it to diff against upstream.
- Keep CI action pins (`uses: actions/checkout@<sha>`) — Dependabot proposes
  updates under review; don't unpin them.

## Releasing

- Versioning is **SemVer**; tags are plain `X.Y.Z` (no `v` prefix).
- A grammar re-vendor is at least a **minor** bump (parser behavior changes).
- Tag and push: `git tag X.Y.Z && git push origin X.Y.Z`.

## Pull requests

- Keep PRs focused (a re-vendor, a CI bump, a docs fix — not all three).
- CI (`swift build`) must pass.
- Sign off your commits (`git commit -s`) to assert the
  [DCO](https://developercertificate.org/).

## Security

Found malicious code in a vendored `parser.c`, a `Package.swift` escape, or a
CI bypass? Do **not** open a public issue — follow
[`.github/SECURITY.md`](.github/SECURITY.md).

## Pull request titles

Title every pull request `[Area] Sentence case`. The area is one bracketed word
naming the part you touched, and the sentence that follows says what the change
does, capitalized like a sentence and with no trailing period.

```
[Grammar] Re-vendor the parser from harn commit a1b2c3d
[CI] Pin the checkout action to a release SHA
[Tests] Cover the const and let keyword forms
```

Common areas here are `Grammar`, `Packaging`, `CI`, `Tests`, and `Docs`.
Describe the change in three to five sentences in the body and say which
command you ran to verify it.

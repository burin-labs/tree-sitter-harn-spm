# Contributing to `tree-sitter-harn-spm`

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

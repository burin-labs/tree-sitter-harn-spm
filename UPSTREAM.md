# Upstream provenance

This repo is a Swift Package Manager wrapper around the in-tree Harn
tree-sitter grammar. The grammar lives in the main Harn repo; we vendor
its generated `parser.c` under `Sources/TreeSitterHarn/src/` so SPM can
build it without needing `tree-sitter-cli`.

## Upstream

- **Source:** [burin-labs/harn/tree-sitter-harn](https://github.com/burin-labs/harn/tree/main/tree-sitter-harn)
- **License:** see Harn repo `LICENSE-MIT` / `LICENSE-APACHE`

## Vendored commit

| Field | Value |
| --- | --- |
| Last reviewed commit | `7f50ebbb531e064a49bfb58c09b473a12aa9e3eb` |
| Provenance | re-vendored from harn canonical grammar on 2026-06-19 |
| Latest harn-repo commit touching `tree-sitter-harn/src/parser.c` as of 2026-06-19 | `7f50ebbb531e064a49bfb58c09b473a12aa9e3eb` |

When you re-vendor, update **Last reviewed commit** to the exact `harn` SHA
whose `tree-sitter-harn/src/parser.c` you copied in, and bump the date.

## How to re-vendor

```sh
# Set these to clean checkouts of both repositories.
HARN_REPO="/path/to/harn"
THIS_REPO="/path/to/tree-sitter-harn-spm"

# Regenerate the parser in the Harn checkout.
(cd "$HARN_REPO/tree-sitter-harn" && npx tree-sitter generate)
UPSTREAM_SHA="$(git -C "$HARN_REPO" rev-parse HEAD)"

# Copy the artifact + headers into this repo:
cp src/parser.c        "$THIS_REPO/Sources/TreeSitterHarn/src/parser.c"
cp src/tree_sitter/*.h "$THIS_REPO/Sources/TreeSitterHarn/src/tree_sitter/" 2>/dev/null || true
# If the grammar ships a custom scanner, copy that too:
[ -f src/scanner.c ] && cp src/scanner.c "$THIS_REPO/Sources/TreeSitterHarn/src/scanner.c"

# Record UPSTREAM_SHA and the current date in the provenance table above.
printf 'Vendored Harn commit: %s\n' "$UPSTREAM_SHA"
```

Review the diff carefully -- a multi-hundred-KB `parser.c` is the supply
chain. If you can't justify each chunk, do not commit it.

## Why this matters

Without this file, reviewers of a re-vendor PR have no way to know which
upstream commit produced the changes. That's how supply-chain attacks land
unnoticed in generated artifacts.

# Upstream provenance

This repo is a Swift Package Manager wrapper around the in-tree Harn
tree-sitter grammar. The grammar lives in the main Harn repo; we vendor
its generated `parser.c` under `Sources/TreeSitterHarn/src/` so SPM can
build it without needing `tree-sitter-cli`.

## Upstream

- **Path:** `~/projects/harn/tree-sitter-harn` (sources for the Harn grammar)
- **Repo:** https://github.com/burin-labs/harn (subdirectory `tree-sitter-harn`)
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
# Regenerate the parser (run from harn checkout):
cd ~/projects/harn/tree-sitter-harn
npx tree-sitter generate
UPSTREAM_SHA="$(git -C ~/projects/harn rev-parse HEAD)"

# Copy the artifact + headers into this repo:
cp src/parser.c        "$THIS_REPO/Sources/TreeSitterHarn/src/parser.c"
cp src/tree_sitter/*.h "$THIS_REPO/Sources/TreeSitterHarn/src/tree_sitter/" 2>/dev/null || true
# If the grammar ships a custom scanner, copy that too:
[ -f src/scanner.c ] && cp src/scanner.c "$THIS_REPO/Sources/TreeSitterHarn/src/scanner.c"

# Update this file with the new SHA.
sed -i '' "s|Last reviewed commit | \`.*\`|Last reviewed commit | \`${UPSTREAM_SHA}\`|" "$THIS_REPO/UPSTREAM.md"
```

Review the diff carefully -- a multi-hundred-KB `parser.c` is the supply
chain. If you can't justify each chunk, do not commit it.

## Why this matters

Without this file, reviewers of a re-vendor PR have no way to know which
upstream commit produced the changes. That's how supply-chain attacks land
unnoticed in generated artifacts.

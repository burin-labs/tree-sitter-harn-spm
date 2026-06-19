# tree-sitter-harn-spm

Swift Package Manager wrapper for the [Harn](https://github.com/burin-labs/harn)
tree-sitter grammar (vendored from `~/projects/harn/tree-sitter-harn`).

## Usage

Add this package to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/burin-labs/tree-sitter-harn-spm.git", from: "0.2.0")
]
```

Then add `TreeSitterHarn` as a dependency of your target.

## Provenance

The vendored `parser.c` is generated from the Harn grammar. See
[`UPSTREAM.md`](./UPSTREAM.md) for the source repo, last-reviewed commit,
and re-vendoring procedure.

## Security

See [`.github/SECURITY.md`](./.github/SECURITY.md) for the disclosure
channel.

## License

MIT (matches the wrapper); the vendored grammar is dual-licensed
MIT/Apache-2.0 from the parent [`burin-labs/harn`](https://github.com/burin-labs/harn)
repo.

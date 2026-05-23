# Security policy

## Reporting a vulnerability

Email **security@burinlabs.com** with the details. Encrypt with our public
key if the report contains exploit material (key available on request).

Please include:

- a clear description of the issue and the impact (e.g. malicious code in
  the vendored `parser.c`, a Package.swift escape that runs arbitrary code
  at resolution time, CI bypass, force-pushed tag)
- a minimal reproduction
- whether the issue has been disclosed publicly or to other parties

## Response window

We aim to:

- acknowledge new reports within **2 business days**
- triage and confirm (or dispute) within **5 business days**
- ship a fix or mitigation within **30 days** for confirmed issues, faster
  for actively-exploited supply-chain bugs

## Scope

In scope:

- `Package.swift`
- the vendored `Sources/*/src/` parser code (regenerated grammar artifacts)
- CI workflows (`.github/workflows/`)
- tag protection / release integrity

Out of scope (report to the appropriate upstream):

- vulnerabilities in the original tree-sitter grammar repo (see
  `UPSTREAM.md` for the citation)
- vulnerabilities in tree-sitter itself ->
  https://github.com/tree-sitter/tree-sitter/security/policy
- vulnerabilities in Swift Package Manager ->
  https://github.com/swiftlang/swift-package-manager/security/policy

## Coordinated disclosure

We support coordinated disclosure. Please give us the response window above
before publishing details. We will credit reporters in the release notes
for the fix unless asked otherwise.

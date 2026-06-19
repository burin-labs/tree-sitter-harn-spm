// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "TreeSitterHarn",
    products: [.library(name: "TreeSitterHarn", targets: ["TreeSitterHarn"])],
    targets: [
        .target(
            name: "TreeSitterHarn",
            path: "Sources/TreeSitterHarn",
            sources: ["src/parser.c", "src/scanner.c"],
            publicHeadersPath: "include",
            cSettings: [.headerSearchPath("src")]
        )
    ]
)

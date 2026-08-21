// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "TreeSitterHarn",
    products: [.library(name: "TreeSitterHarn", targets: ["TreeSitterHarn"])],
    dependencies: [
        .package(
            url: "https://github.com/tree-sitter/swift-tree-sitter.git",
            .upToNextMinor(from: "0.25.0")
        )
    ],
    targets: [
        .target(
            name: "TreeSitterHarn",
            path: "Sources/TreeSitterHarn",
            sources: ["src/parser.c", "src/scanner.c"],
            publicHeadersPath: "include",
            cSettings: [.headerSearchPath("src")]
        ),
        .testTarget(
            name: "TreeSitterHarnTests",
            dependencies: [
                "TreeSitterHarn",
                .product(name: "SwiftTreeSitter", package: "swift-tree-sitter"),
            ],
            resources: [.copy("Fixtures")]
        ),
    ]
)

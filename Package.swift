// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "TreeSitterHarn",
    products: [.library(name: "TreeSitterHarn", targets: ["TreeSitterHarn"])],
    targets: [
        .target(
            name: "TreeSitterHarn",
            path: "Sources/TreeSitterHarn",
            sources: ["src/parser.c"],
            publicHeadersPath: "include",
            cSettings: [.headerSearchPath("src")]
        )
    ]
)

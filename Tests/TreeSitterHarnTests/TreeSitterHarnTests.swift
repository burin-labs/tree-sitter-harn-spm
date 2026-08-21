import SwiftTreeSitter
import TreeSitterHarn
import XCTest

final class TreeSitterHarnTests: XCTestCase {
    private struct Fixture {
        let name: String
    }

    func testRepresentativeFixturesHaveStableParseTrees() throws {
        let fixtures = [
            Fixture(name: "import_and_loop"),
            Fixture(name: "control_flow"),
            Fixture(name: "types"),
        ]

        let parser = Parser()
        try parser.setLanguage(Language(language: tree_sitter_harn()))

        for fixture in fixtures {
            let url = try XCTUnwrap(
                Bundle.module.url(
                    forResource: fixture.name,
                    withExtension: "harn",
                    subdirectory: "Fixtures"
                ),
                "missing fixture \(fixture.name)"
            )
            let source = try String(contentsOf: url, encoding: .utf8)
            let expectedURL = try XCTUnwrap(
                Bundle.module.url(
                    forResource: fixture.name,
                    withExtension: "sexp",
                    subdirectory: "Fixtures"
                ),
                "missing expected tree for \(fixture.name)"
            )
            let expectedTree = try String(contentsOf: expectedURL, encoding: .utf8)
                .trimmingCharacters(in: .whitespacesAndNewlines)
            let tree = try XCTUnwrap(parser.parse(source), "failed to parse \(fixture.name)")
            let root = try XCTUnwrap(tree.rootNode, "missing root for \(fixture.name)")
            let actualTree = try XCTUnwrap(
                root.sExpressionString,
                "missing s-expression for \(fixture.name)"
            )

            XCTAssertFalse(root.hasError, "\(fixture.name) contains an ERROR node: \(actualTree)")
            XCTAssertEqual(actualTree, expectedTree, "grammar drifted for \(fixture.name)")
        }
    }
}

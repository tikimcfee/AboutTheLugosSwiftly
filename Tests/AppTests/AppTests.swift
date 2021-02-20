@testable import App
import XCTVapor
import CSS
import StylesData
import VendorNetworking

final class AppTests: XCTestCase {
    func testHelloWorld() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        _ = VaporRouteRenderingContainer(vaporApp: app)
    }
	
	func testParent() {
		let styles = Class(BodyNames.navigationContainer.rawValue) {
            float(.left)
            width(.percent(10))
            display(.inlineBlock)
            justifyContent(.flexStart)
            Anchor {
                textDecoration(.none)
                color(ColorPalette.NavigationBar.linkText)
            }
            Anchor {
                textDecoration(.underline)
                color(ColorPalette.NavigationBar.linkTextHover)
            }.pseudo(.hover)
        }
		print(styles.string())
	}

    struct GraphQLRequestRoot {
        let query: String
    }

    func test() {
        let token = ""
        let helper = GithubApiHelper(
            config: GithubApiHelper.Config(
                token: token
            )
        )
        let request = CommitsFetchRequest(
            owner: "tikimcfee",
            repo: "AboutTheLugosSwiftly",
            sha: "master",
            count: 3
        )

        let expect = XCTestExpectation(description: "Fetch")
        helper.fetchCommits(request) { result in
            switch result {
            case .success(let fetch):
                print(fetch)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 5)
    }
}

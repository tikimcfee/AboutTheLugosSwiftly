@testable import App
import XCTVapor
import CSS
import StylesData
import VendorNetworking
import Filesystem

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

    func test() {
        let token = PrivateFileHelper.githubBearerToken
        let helper = GithubApiHelper(
            config: GAHConfig(
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

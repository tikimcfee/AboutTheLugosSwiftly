@testable import App
import XCTVapor
import CSS
import StylesData

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
}

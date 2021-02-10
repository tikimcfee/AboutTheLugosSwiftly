@testable import App
import XCTVapor
import CSS

final class AppTests: XCTestCase {
    func testHelloWorld() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        let renderer = VaporRouteRenderer(vaporApp: app)

        
    }
	
	func testParent() {
		let styles = Stylesheet {
			Class("hello-world") {
				background(.red)
				Parent {
					Class("blue") {
						background(.blue)
						Child {
							Div { color(.red) }
							Paragraph { color(.green) }
						}
					}
				}

			}
		}
		print(styles.string())
	}
}

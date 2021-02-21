@testable import App
import XCTVapor
import CSS
import StylesData
import VendorNetworking
import SharedAppTools

final class AppTests: XCTestCase {
	
	var VAPOR_APP: Application! 
	
	override func setUp() {
		VAPOR_APP = Application(.testing)
	}
	
	override func tearDown() {
		VAPOR_APP.shutdown()
	}
	
    func testHelloWorld() throws {
        _ = VaporRouteRenderingContainer(vaporApp: VAPOR_APP)
    }

	func testFileAttributes() throws {
		do {
			let attributes = try FileManager.default
				.attributesOfItem(atPath: rootFile(named: "global.css").path)
			let date = attributes[.modificationDate] as? Date
			print("Found: \(date?.description ?? "<NO_DATE>")")
			XCTAssert(date != nil, "Modification date missing on file")
		} catch {
			XCTFail(error.localizedDescription)
		}
	}
    
	func testLockReadWriteCss() throws {
		let testName = rawFile(named: "global.css")
		
		let manualCssRead = try! Data(contentsOf: testName)
		print("Have:\n\(manualCssRead)\n")
		let reader = LockingResourceReader()
		XCTAssert(reader[testName] == manualCssRead, "Cached reader did not return manual read")
		XCTAssert(reader[testName] == reader[testName], "Cached successive reads are unequal")
		let manualRefresh = "body { color: \"#cccccc\" }".data(using: .utf8)!
		reader[testName] = manualRefresh
		XCTAssert(reader[testName] == manualRefresh, "Updated entry did not return correctly")
	}
	
	func testChangeTracker() throws {
		let tracker = FileChangeTracker()
		tracker.errorHook = { XCTFail($0.localizedDescription) }
		let testFile = rootFile(named: "global.css")
		
		let firstCall = tracker.hasFileChanged(testFile)
		XCTAssert(firstCall == true, "First file read should always return 'true', since it has not yet been tracked")
		let secondCall = tracker.hasFileChanged(testFile)
		XCTAssert(secondCall == false, "First and second checks should always return 'true/false'")
		
		try appendToFile(testFile, "\n".data(using: .utf8)!)
		let thirdCall = tracker.hasFileChanged(testFile)
		XCTAssert(thirdCall == true, "Should always return 'true' after writing to file")
	}
}

final class VendorNetworkingTests: XCTestCase {
	func testGithubTokenAndFetch() {
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

final class StylingTests: XCTestCase {
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

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
	
    func testContainerInstantiation() throws {
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
		let testName = rootFile(named: "global.css")
		
		let manualCssRead = try! String(contentsOf: testName)
		print("Have:\n\(manualCssRead)\n")
		
        let reader = LockingResourceReader()
        XCTAssert(try! reader.get(testName) == manualCssRead, "Cached reader did not return manual read")
        
        let (first, second) = (try! reader.get(testName), try! reader.get(testName))
		XCTAssert(first == second, "Cached successive reads are unequal")
		
        let manualRefresh = "body { color: \"#cccccc\" }"
        reader.set(testName, for: manualRefresh)
		XCTAssert(try! reader.get(testName) == manualRefresh, "Updated entry did not return correctly")
	}
	
	func testChangeTracker() throws {
		let tracker = FileChangeTracker()
		let testFile = rootFile(named: "global.css")
		
		let firstCall = try! tracker.hasFileChanged(testFile)
		XCTAssert(firstCall == true, "First file read should always return 'true', since it has not yet been tracked")
		let secondCall = try! tracker.hasFileChanged(testFile)
		XCTAssert(secondCall == false, "First and second checks should always return 'true/false'")
		
		try appendToFile(testFile, "\n".data(using: .utf8)!)
		let thirdCall = try! tracker.hasFileChanged(testFile)
		XCTAssert(thirdCall == true, "Should always return 'true' after writing to file")
        
        let fourthCall = try! tracker.hasFileChanged(testFile)
        XCTAssert(fourthCall == false, "Should always return 'false' after reading a second time")
        
        let multipleCallsAllFalse =
            (0...10)
            .map { _ in try! tracker.hasFileChanged(testFile) }
            .allSatisfy { $0 == false }
        XCTAssert(multipleCallsAllFalse == true, "Any number of calls to an unchanged file should always return 'false'")
	}
}

final class ArticleFileTests: XCTestCase {
    
    override func setUp() {
        continueAfterFailure = false
    }
    
    override func tearDown() {
        LOG_PAD()
    }
    
    private func loadXXXXTestArticle() throws -> ArticleFile {
        let testArticleRoot = xxxxTestUrl
        let contents = try testArticleRoot.defaultContents()
        var sniffState = ArticleSniffState()
        guard let file = try sniffState.makeFrom(urls: contents) else {
            fatalError("Could not parse article from \(testArticleRoot)")
        }
        return file
    }
    
    func testUpdateDate() throws {
        LOG_PAD()
        
        var file = try loadXXXXTestArticle()
        let metaOriginalDate = file.meta.postedAt
        let metaNewDate = metaOriginalDate.advanced(by: TimeInterval(60 * 60 * 12))
        
        file.meta.postedAt = metaNewDate
        try file.commitMetaToPath()
        
        let rereadFile = try loadXXXXTestArticle()
        XCTAssert(file.meta == rereadFile.meta, "Article meta does not match :\n\nOriginal:\n\(file.meta)\n\nReread:\n\(rereadFile.meta)")
    }
    
    func testSaveAndDeleteArticle() throws {
        LOG_PAD()
        
        let articleCreator = ArticleCreator(rootDirectory: testDataDirectory)
        let testLoader = ArticleLoaderComponent(rootDirectory: testDataDirectory)
        testLoader.refreshArticles()
    
        let originalFile = try loadXXXXTestArticle()
        let originalBody = try originalFile.articleContents()
        
        var updatedMeta = originalFile.meta
        updatedMeta.id = "simple-gibbons-liverspots"
        
        try articleCreator.createNew(article: originalBody, with: updatedMeta)
        testLoader.refreshArticles()
        guard let reloadedFile = testLoader.articleLookup[updatedMeta.id] else {
            XCTFail("Failed to reload newly written article")
            return
        }
        
        XCTAssert(updatedMeta == reloadedFile.meta, "Reread file has mismatched meta")
        let reloadedContents = try reloadedFile.articleContents()
        XCTAssert(originalBody == reloadedContents, "Reread file has mismatched body")
        
        try articleCreator.delete(article: updatedMeta)
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

func LOG_PAD() { print("\n\n\n\n") }

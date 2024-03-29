import Foundation

public typealias ArticleList = [ArticleFile]
public typealias ArticleIndex = [String: ArticleFile]

public struct ArticleFile {
    public var meta: ArticleMeta
    public var metaFilePath: URL
    public var articleFilePath: URL
    
    public init(meta: ArticleMeta,
                metaFilePath: URL,
                articleFilePath: URL) {
        self.meta = meta
        self.metaFilePath = metaFilePath
        self.articleFilePath = articleFilePath
    }

    public func articleContents() throws -> String {
        try String(contentsOf: articleFilePath)
    }
}

public struct ArticleMeta: Equatable, Codable {
    public var id: String
    public var name: String
    public var summary: String
    public var postedAt: TimeInterval
    
    public init(id: String,
                name: String,
                summary: String,
                postedAt: TimeInterval) {
        self.id = id
        self.name = name
        self.summary = summary
        self.postedAt = postedAt
    }
}

public extension ArticleFile {
    private static let articleJsonDecoder = JSONDecoder()
    private static let articleJsonEncoder = JSONEncoder()
    
    func commitMetaToPath() throws {
        let metaJson = try Self.articleJsonEncoder.encode(meta)
        try metaJson.write(to: metaFilePath)
    }
}

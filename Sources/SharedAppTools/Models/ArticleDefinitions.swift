import Foundation

public typealias ArticleList = [ArticleFile]
public typealias ArticleIndex = [String: ArticleFile]

public struct ArticleMeta: Codable {
    public var id: String
    public var name: String
    public var summary: String
    public var postedAt: TimeInterval
    
    public init(id: String,
                name: String,
                summary: String,
                postedAtEpoch: TimeInterval) {
        self.id = id
        self.name = name
        self.summary = summary
        self.postedAtEpoch = postedAtEpoch
    }
}

public struct ArticleFile {
    public var meta: ArticleMeta
    public var articleFilePath: URL
    
    public init(meta: ArticleMeta,
                articleFilePath: URL) {
        self.meta = meta
        self.articleFilePath = articleFilePath
    }

    public func articleContents() throws -> String {
        try String(contentsOf: articleFilePath)
    }
}

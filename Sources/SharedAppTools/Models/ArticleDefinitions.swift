import Foundation

public typealias ArticleList = [ArticleFile]
public typealias ArticleIndex = [String: ArticleFile]

public struct ArticleMeta: Codable {
    public let id: String
    public let name: String
    public let summary: String
    
    public init(id: String,
                name: String,
                summary: String) {
        self.id = id
        self.name = name
        self.summary = summary
    }
}

public struct ArticleFile {
    public let meta: ArticleMeta
    public let articleFilePath: URL
    
    public init(meta: ArticleMeta,
                articleFilePath: URL) {
        self.meta = meta
        self.articleFilePath = articleFilePath
    }

    public func articleContents() throws -> String {
        try String(contentsOf: articleFilePath)
    }
}
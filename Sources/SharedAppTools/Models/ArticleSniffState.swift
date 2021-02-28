import Foundation

public extension String {
    var isMarkdown: Bool { hasSuffix(".md") }
    var isMeta: Bool { hasSuffix("meta.json") }
}

public struct ArticleSniffState {
    private static let decoder = JSONDecoder()
    public var mainMarkdownPath: URL?
    public var metaPath: URL?
    
    public init(mainMarkdownPath: URL? = nil,
                metaPath: URL? = nil) {
        self.mainMarkdownPath = mainMarkdownPath
        self.metaPath = metaPath
    }
    
    public mutating func consume(url: URL) {
        var urlIsDirectory: ObjCBool = false
        guard fileManager.fileExists(atPath: url.path, isDirectory: &urlIsDirectory),
              !urlIsDirectory.boolValue
        else { return }
        if url.path.isMarkdown { mainMarkdownPath = url }
        else if url.path.isMeta { metaPath = url }
    }

    public func makeArticleFile() throws -> ArticleFile? {
        guard let markdownUrl = mainMarkdownPath,
              let metaUrl = metaPath
        else { return nil }
        let metaData = try Data(contentsOf: metaUrl)
        let meta = try Self.decoder.decode(ArticleMeta.self, from: metaData)
        return ArticleFile(
            meta: meta,
            metaFilePath: metaUrl,
            articleFilePath: markdownUrl
        )
    }
    
    public mutating func makeFrom(urls: [URL]) throws -> ArticleFile? {
        for url in urls {
            consume(url: url)
            if let article = try makeArticleFile() {
                return article
            }
        }
        return nil
    }
}

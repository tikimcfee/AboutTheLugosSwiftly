import Foundation
import Vapor

struct ArticleMeta: Codable {
    let id: String
    let name: String
    let summary: String
}

struct ArticleFile {
    let meta: ArticleMeta
    let articleFilePath: URL

    func articleContents() throws -> String {
        try String(contentsOf: articleFilePath)
    }
}

typealias ArticleList = [ArticleFile]
typealias ArticleIndex = [String: ArticleFile]

class ArticleLoader {

    let vaporApp: Application
    private let refreshTime = 60 * 60
    private let loadingQueue = DispatchQueue(label: "ArticleLoader", qos: .background)

    var currentArticles = ArticleList()
    var articleLookup = ArticleIndex()

    init(vaporApp: Application) {
        self.vaporApp = vaporApp
        kickoffArticleLoading()
    }

    private func kickoffArticleLoading() {
        loadingQueue.async { self.refreshArticles() }
    }

    private func refreshArticles() {
        vaporApp.logger.info("Starting article lookup")

        (currentArticles, articleLookup) =
            discoverArticles()

        vaporApp.logger.info("Article lookup complete, refreshing in \(refreshTime) seconds")
        loadingQueue.asyncAfter(
            deadline: .now() + .seconds(refreshTime),
            execute: refreshArticles
        )
    }

    private func discoverArticles() -> (ArticleList, ArticleIndex) {
        var allArticles = ArticleList()
        var index = ArticleIndex()
        allArticleDirectories().forEach { articleDirectory in
            var state = ArticleSniffState()
            for fileUrl in loadContents(of: articleDirectory) {
                state.consume(url: fileUrl)
                if append(to: &allArticles, in: &index, from: state) {
                    break
                }
            }
        }
        return (allArticles, index)
    }

    private func allArticleDirectories() -> [URL] {
        do {
            return try rootSubDirectory(named: "articles")
                .defaultContents()
                .filter { $0.hasDirectoryPath }
        } catch {
            vaporApp.logger.report(error: error)
            return []
        }
    }

    private func loadContents(of url: URL) -> [URL] {
        do {
            return try url
                .defaultContents()
                .filter { !$0.hasDirectoryPath }
        } catch {
            vaporApp.logger.report(error: error)
            return []
        }
    }

    private func append(to list: inout [ArticleFile],
                        in index: inout [String: ArticleFile],
                        from state: ArticleSniffState) -> Bool {
        do {
            if let file = try state.makeArticleFile() {
                list.append(file)
                index[file.meta.id] = file
                return true
            }
        } catch {
            vaporApp.logger.report(error: error)
        }
        return false
    }
}

private extension URL {
    func defaultContents() throws -> [URL] {
        try fileManager.contentsOfDirectory(
            at: self,
            includingPropertiesForKeys: nil,
            options: .skipsHiddenFiles
        )
    }
}

private extension String {
    var isMarkdown: Bool { hasSuffix(".md") }
    var isMeta: Bool { hasSuffix("meta.json") }
}

private struct ArticleSniffState {
    var mainMarkdownPath: URL?
    var metaPath: URL?

    mutating func consume(url: URL) {
        var urlIsDirectory: ObjCBool = false
        guard fileManager.fileExists(atPath: url.path, isDirectory: &urlIsDirectory),
              !urlIsDirectory.boolValue
        else { return }
        if url.path.isMarkdown { mainMarkdownPath = url }
        else if url.path.isMeta { metaPath = url }
    }

    func makeArticleFile() throws -> ArticleFile? {
        guard let markdownUrl = mainMarkdownPath,
              let metaUrl = metaPath
        else { return nil }
        let metaData = try Data(contentsOf: metaUrl)
        let meta = try jsonDecoder.decode(ArticleMeta.self, from: metaData)
        return ArticleFile(
            meta: meta,
            articleFilePath: markdownUrl
        )
    }
}

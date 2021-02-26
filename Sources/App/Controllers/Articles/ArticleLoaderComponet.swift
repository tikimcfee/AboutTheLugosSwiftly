import Foundation
import Vapor
import SharedAppTools

class ArticleLoaderComponent {
    let vaporApp: Application
    private let refreshTime = 60 * 60
    private let loadingQueue = DispatchQueue(label: "ArticleLoader", qos: .background)

    private let loader = ArticleLoader()
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

        do {
            (currentArticles, articleLookup) = try discoverArticles()
        } catch {
            vaporApp.logger.error("Hard error during article refresh")
            vaporApp.logger.report(error: error)
        }

        vaporApp.logger.info("Article lookup complete, refreshing in \(refreshTime) seconds")
        loadingQueue.asyncAfter(
            deadline: .now() + .seconds(refreshTime),
            execute: refreshArticles
        )
    }
    
    private func discoverArticles() throws -> (ArticleList, ArticleIndex) {
        var allArticles = ArticleList()
        var index = ArticleIndex()
        try allArticleDirectories().forEach { articleDirectory in
            try self.loader.sniff(articleDirectory, into: &allArticles, index: &index)
        }
        return (allArticles, index)
    }
    
    private func allArticleDirectories() throws -> [URL] {
        try rootSubDirectory(named: "articles")
            .defaultContents()
            .filter { $0.hasDirectoryPath }
    }
}

class ArticleLoader {
    public func sniff(_ directory: URL,
                       into list: inout ArticleList,
                       index: inout ArticleIndex) throws {
        var state = ArticleSniffState()
        for fileUrl in try directory.defaultContents() {
            guard !fileUrl.hasDirectoryPath else { continue }
            state.consume(url: fileUrl)
            if try append(to: &list, in: &index, from: state) {
                break
            }
        }
    }

    private func append(to list: inout [ArticleFile],
                        in index: inout [String: ArticleFile],
                        from state: ArticleSniffState) throws -> Bool {
        guard let file = try state.makeArticleFile() else {
            return false
        }
        list.append(file)
        index[file.meta.id] = file
        return true
    }
}

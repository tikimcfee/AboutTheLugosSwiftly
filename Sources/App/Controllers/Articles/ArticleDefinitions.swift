import Foundation

typealias ArticleList = [ArticleFile]
typealias ArticleIndex = [String: ArticleFile]

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

import Foundation
import Ink
import Html
import Vapor

struct ArticleRenderer {
    let vaporApp: Vapor.Application
    let loader: ArticleLoader

    let parser = MarkdownParser()

    func render(articleId: String) {
        guard let article = loader.articleLookup[articleId]
        else { return }

        do {
            let rawArticle = try article.articleContents()
            let markdown = parser.html(from: rawArticle)
            
        } catch {
            vaporApp.logger.report(error: error)
        }
    }
}

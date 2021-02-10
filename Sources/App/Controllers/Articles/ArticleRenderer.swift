import Ink
import Vapor

struct ArticleRenderer {
    let vaporApp: Vapor.Application
    let loader: ArticleLoader

    let parser = MarkdownParser()

    func render(articleId: String, _ completed: (String) -> Void) {
        guard let article = loader.articleLookup[articleId]
        else { return }

        do {
            let rawArticle = try article.articleContents()
            let markdown = parser.html(from: rawArticle)
            completed(markdown)
        } catch {
            vaporApp.logger.report(error: error)
        }
    }
}

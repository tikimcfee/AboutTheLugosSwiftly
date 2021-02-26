import Ink
import Vapor

struct ArticleRenderer {
    let vaporApp: Vapor.Application
    let loader: ArticleLoaderComponent

    func render(articleId: String, _ completed: (String) -> Void) {
        guard let article = loader.articleLookup[articleId]
        else { return }

        do {
            let rawArticle = try article.articleContents()
            let markdown = markdownParser.html(from: rawArticle)
            completed(markdown)
        } catch {
            vaporApp.logger.report(error: error)
        }
    }

    func render(articleId: String) -> String {
        guard let article = loader.articleLookup[articleId]
        else { return "" }

        do {
            let rawArticle = try article.articleContents()
            let markdown = markdownParser.html(from: rawArticle)
            return markdown
        } catch {
            vaporApp.logger.report(error: error)
            return ""
        }
    }
}

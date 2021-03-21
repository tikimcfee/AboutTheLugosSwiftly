import MarkdownKit
import SharedAppTools

struct ArticleRenderer {
    let loader: VaporArticleLoader

    func render(articleId: String, _ completed: (String) -> Void) {
        guard let article = loader[articleId]
        else { return }

        do {
            let rawArticle = try article.articleContents()
            let parsed = MarkdownParser.standard.parse(rawArticle)
            let html = HtmlGenerator.standard.generate(doc: parsed)
            completed(html)
        } catch {
            LuLog.error(error.localizedDescription)
        }
    }

    func render(articleId: String) -> String {
        guard let article = loader[articleId]
        else { return "" }

        do {
            let rawArticle = try article.articleContents()
            let parsed = MarkdownParser.standard.parse(rawArticle)
            let markdown = HtmlGenerator.standard.generate(doc: parsed)
            return markdown
        } catch {
            LuLog.error(error.localizedDescription)
            return ""
        }
    }
}

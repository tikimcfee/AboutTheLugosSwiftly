import SharedAppTools
import Down

struct ArticleRenderer {
    let loader: VaporArticleLoader

    func render(articleId: String) -> String {
        guard let article = loader[articleId]
        else { return "" }

        do {
            let rawArticle = try article.articleContents()
            let markdownHTML = try Down(markdownString: rawArticle).toHTML(.smartUnsafe)
            return markdownHTML
        } catch {
            AppLog.error(error.localizedDescription)
            return ""
        }
    }
}

import SharedAppTools

struct ArticleRenderer {
    let loader: VaporArticleLoader

    func render(articleId: String) -> String {
        guard let article = loader[articleId]
        else { return "" }

        do {
            let rawArticle = try article.articleContents()
            guard let markdownHTML = rawArticle.markdownToHTML else {
                throw MarkdownError.markdownNotParsed
            }
            return markdownHTML
        } catch {
            AppLog.error(error.localizedDescription)
            return ""
        }
    }
}

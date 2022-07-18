import SharedAppTools
import Down

struct ArticleRenderer {
    let loader: VaporArticleLoader
    
//    private let articleCache = ConcurrentDictionary<String, String>()

    func render(articleId: String) -> String {
//        if let cached = articleCache[articleId] { return cached }
        guard let article = loader[articleId] else { return "" }

        do {
            let rawArticle = try article.articleContents()
            let markdown = Down(markdownString: rawArticle)
            let markdownHTML = try markdown.toHTML(.smartUnsafe)
//            articleCache[articleId] = markdownHTML
            return markdownHTML
        } catch {
            AppLog.error(error.localizedDescription)
            return ""
        }
    }
    
    func renderMarkdown(articleId: String) -> Down {
        guard let article = loader[articleId] else {
            return Down(markdownString: "")
        }
        
        do {
            let rawArticle = try article.articleContents()
            let markdown = Down(markdownString: rawArticle)
            return markdown
        } catch {
            AppLog.error(error.localizedDescription)
            return Down(markdownString: "")
        }
    }
}

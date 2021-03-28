import Foundation
import Vapor
import SharedAppTools
import Html
import MarkdownKit

struct ArticleListRouteBuilder: AppRouteBuilderType {
    let appRoute: AppRoutes = .articles
    let baseRenderer: HTMLRenderer
    let articleLoader: VaporArticleLoader
    
    func attach(to app: Vapor.Application) {
        app.get(appRoute.path) { request in
            request.usingThreadPool {
                self.response(from: request)
            }
        }
    }
    
    func response(from request: Request) -> Response {
        let orderedList = Node.ol(
            .fragment(
                articleLoader.currentArticles.map { article in
                    article.listItem
                }
            )
        )
        return baseRenderer.renderRouteWith {[
            orderedList
        ]}.asHtmlResponse
    }
}

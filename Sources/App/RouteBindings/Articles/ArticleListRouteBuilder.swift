import Foundation
import Vapor
import SharedAppTools
import Html

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
                articleLoader.currentFiles.map { article in
                    article.listItem(appRoute)
                }
            )
        )
        return baseRenderer.renderRouteWith {[
            orderedList
        ]}.asHtmlResponse
    }
}

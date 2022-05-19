import Foundation
import Vapor
import SharedAppTools
import Html

struct ArticleRouteBuilder: AppRouteBuilderType {
    let appRoute: AppRoutes = .articles
    let baseRenderer: HTMLRenderer
    
    let articleRenderer: ArticleRenderer
    
    func attach(to app: Vapor.Application) {
        app.get([appRoute.path, ":id"]) { request in
            request.usingThreadPool {
                self.response(from: request)
            }
        }
    }
    
    func response(from request: Request) -> Response {
        guard let id = request.parameters.get("id") else {
            return request.redirect(to: AppRoutes.root.rawValue)
        }
        let markdownHtml = articleRenderer.render(articleId: id)
        return baseRenderer.renderRouteWith {
            [.raw(markdownHtml)]
        }.asHtmlResponse
    }
}

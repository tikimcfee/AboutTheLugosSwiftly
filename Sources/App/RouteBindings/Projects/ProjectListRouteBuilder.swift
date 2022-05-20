import Foundation
import Vapor
import SharedAppTools
import Html

struct ProjectListRouteBuilder: AppRouteBuilderType {
    let appRoute: AppRoutes = .projects
    let baseRenderer: HTMLRenderer
    let projectLoader: VaporArticleLoader
    
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
                projectLoader.currentFiles.map { article in
                    article.listItem(appRoute)
                }
            )
        )
        return baseRenderer.renderRouteWith {[
            orderedList
        ]}.asHtmlResponse
    }
}

import Foundation
import Vapor
import SharedAppTools
import Html

struct HomeRouteBuilder: AppRouteBuilderType {
    let appRoute: AppRoutes = .root
    let baseRenderer: HTMLRenderer
    
    func attach(to app: Vapor.Application) {
        app.get(appRoute.path) { request in
            request.usingThreadPool {
                self.response(from: request)
            }
        }
    }
    
    func response(from request: Request) -> Response {
        baseRenderer.renderRouteWith {
            [.raw("Hello, world!")]
        }.asHtmlResponse
    }
}

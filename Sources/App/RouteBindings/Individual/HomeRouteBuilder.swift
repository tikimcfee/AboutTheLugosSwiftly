import Foundation
import Vapor
import SharedAppTools
import Html
import Down

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
        do {
            let aboutFile = rawFile(named: "about.md")
            let aboutContents = try String(contentsOf: aboutFile)
            let markdownHTML = try Down(markdownString: aboutContents).toHTML(.smartUnsafe)
            
            return baseRenderer.renderRouteWith{[
                .raw(markdownHTML)
            ]}.asHtmlResponse
        } catch {
            AppLog.error("Response error: \(error)")
            return request.redirect(to: AppRoutes.root.rawValue)
        }
    }
}

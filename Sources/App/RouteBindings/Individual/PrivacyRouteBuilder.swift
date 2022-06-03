import Foundation
import Vapor
import SharedAppTools
import Html
import Down

struct PrivacyRouteBuilder: AppRouteBuilderType {
    let appRoute: AppRoutes = .privacyAndTerms
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
            let privacyFile = rawFile(named: "privacy.md")
            let privacyContents = try String(contentsOf: privacyFile)
            let markdownHTML = try Down(markdownString: privacyContents).toHTML(.smartUnsafe)
            
            return baseRenderer.renderRouteWith{[
                .raw(markdownHTML)
            ]}.asHtmlResponse
        } catch {
            AppLog.error("Response error: \(error)")
            return request.redirect(to: AppRoutes.root.rawValue)
        }
    }
}

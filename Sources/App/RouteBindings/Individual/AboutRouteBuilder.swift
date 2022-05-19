import Foundation
import Vapor
import SharedAppTools
import Html
import PerfectMarkdown

enum MarkdownError: Error {
    case markdownNotParsed
}

struct AboutRouteBuilder: AppRouteBuilderType {
    let appRoute: AppRoutes = .about
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
            
            guard let markdownHTML = aboutContents.markdownToHTML else {
                throw MarkdownError.markdownNotParsed
            }
            
            return baseRenderer.renderRouteWith{[
                .raw(markdownHTML)
            ]}.asHtmlResponse
        } catch {
            AppLog.error("Response error: \(error)")
            return request.redirect(to: AppRoutes.root.rawValue)
        }
    }
}


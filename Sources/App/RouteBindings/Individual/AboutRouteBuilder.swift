import Foundation
import Vapor
import SharedAppTools
import MarkdownKit
import Html

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
            let markdown = MarkdownParser.standard.parse(aboutContents)
            let aboutHtml = HtmlGenerator.standard.generate(doc: markdown)
            return baseRenderer.renderRouteWith{[
                .raw(aboutHtml)
            ]}.asHtmlResponse
        } catch {
            return request.redirect(to: AppRoutes.root.rawValue)
        }
    }
}

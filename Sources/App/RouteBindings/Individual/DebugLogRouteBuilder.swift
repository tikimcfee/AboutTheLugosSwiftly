import Foundation
import Vapor
import SharedAppTools
import Html

struct DebugLogRouteBuilder: AppRouteBuilderType {
    let appRoute: AppRoutes = .logs
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
            let logFile = AppLog.globalLogFile
            let logs = try String(contentsOf: logFile)
            let logBox = Node.textarea(
                attributes: [.style(safe: Self.styleText)],
                logs
            )
            return baseRenderer.renderRouteWith {
                [logBox]
            }.asHtmlResponse
        } catch {
            return HTMLResponse.makeErrorResponse(from: error.localizedDescription)
        }
    }
}

private extension DebugLogRouteBuilder {
    static let styleText: StaticString =
"""
font-family: 'Courier New', monospace;
min-height: 1024px;
"""
}

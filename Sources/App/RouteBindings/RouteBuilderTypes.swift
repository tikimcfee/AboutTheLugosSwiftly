import Foundation
import Vapor
import SharedAppTools
import MarkdownKit
import Html

protocol AppRouteBuilderType {
    func attach(to app: Vapor.Application)
    func response(from request: Request) -> Response
}

extension Request {
    func usingThreadPool(
        _ operation: @escaping () throws -> Response
    ) -> EventLoopFuture<Response> {
        application.threadPool.runIfActive(eventLoop: eventLoop) {
            try operation()
        }
    }
}

extension String {
    var asHtmlResponse: Response {
        HTMLResponse.makeResponse(from: self)
    }
}

class HTMLResponse {
    static func headers() -> HTTPHeaders {
        var headers = HTTPHeaders()
        headers.add(name: .contentType, value: "text/html")
        return headers
    }
    
    static func makeResponse(from body: String) -> Response {
        Response(status: .ok, headers: headers(), body: .init(string: body))
    }
    
    static func makeErrorResponse(from message: String) -> Response {
        Response(status: .internalServerError, headers: headers(), body: .init(string: message))
    }
}

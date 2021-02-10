import Vapor

public class VaporRouteRenderer {

    let vaporApp: Application

    lazy var baseRenderer: BaseRenderer = {
        BaseRenderer(vaporApp: vaporApp)
    }()

    public init(vaporApp: Application) {
        self.vaporApp = vaporApp

        buildRoutes()
    }

    func buildRoutes() {
        vaporApp.middleware.use(
            FileMiddleware(publicDirectory: vaporApp.directory.publicDirectory)
        )

        vaporApp.get { req -> Response in
            return self.baseRenderer
                .renderRoute()
                .asHtmlResponse
        }
    }

}

private extension String {
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
}

import Vapor

enum AppRoutes: String, CustomStringConvertible {
    case root = ""
    case about
    case articles
    case article

    var path: PathComponent { .constant(rawValue) }
    var absolute: String { "/\(rawValue)" }

    var description: String {
        switch self {
        case .root:
            return "Home"
        case .about:
            return "About"
        case .article:
            return "Article"
        case .articles:
            return "Articles"
        }
    }

    static var displayRoutes: [AppRoutes] {
        [.root, .about, .articles]
    }
}

public class VaporRouteRenderingContainer {

    let vaporApp: Application

    lazy var baseRenderer: HTMLRenderer = {
        HTMLRenderer(vaporApp: vaporApp)
    }()

    let articleRenderer: ArticleRenderer

    public init(vaporApp: Application) {
        self.vaporApp = vaporApp
        self.articleRenderer = ArticleRenderer(
            vaporApp: vaporApp,
            loader: ArticleLoader(vaporApp: vaporApp)
        )

        buildRoutes()
    }

    func buildRoutes() {
        vaporApp.middleware.use(
            FileMiddleware(publicDirectory: vaporApp.directory.publicDirectory)
        )

        vaporApp.get(AppRoutes.root.path) { _ in
            ""
        }

        vaporApp.get([AppRoutes.articles.path]) { req in
            ""
        }

        vaporApp.get([AppRoutes.articles.path, ":id"]) { req in
            req.application.threadPool.runIfActive(eventLoop: req.eventLoop) {
                self.loadArticle(req)
            }
        }
    }

    private func loadArticle(_ req: Request) -> Response {
        guard let id = req.parameters.get("id"),
              let parsed = articleRenderer.render(articleId: id)
        else {
            return req.redirect(to: AppRoutes.root.rawValue)
        }

        return baseRenderer.renderRouteWith {
            [.raw(parsed)]
        }.asHtmlResponse
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

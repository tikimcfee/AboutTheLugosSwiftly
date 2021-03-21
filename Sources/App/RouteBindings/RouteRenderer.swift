import Vapor
import Html
import StylesData
import SharedAppTools
import MarkdownKit

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

    let vaporApp: Vapor.Application

    lazy var baseRenderer: HTMLRenderer = {
        HTMLRenderer(vaporApp: vaporApp)
    }()

    let articleLoader: VaporArticleLoader
    let articleRenderer: ArticleRenderer

    public init(vaporApp: Vapor.Application) {
        self.vaporApp = vaporApp
        self.articleLoader = VaporArticleLoader()
        self.articleRenderer = ArticleRenderer(loader: articleLoader)

        configureServer()
        buildRoutes()
    }

    func configureServer() {
        generateAssets()
    }

    func generateAssets() {
        LuLog.trace("Generating assets...")
        do {
            try AssetWriter.writeAllAssets()
            LuLog.trace("Assets generated.")
        } catch {
            LuLog.error(error.localizedDescription)
        }
    }

    func buildRoutes() {
        vaporApp.middleware.use(
            FileMiddleware(publicDirectory: vaporApp.directory.publicDirectory)
        )

        vaporApp.get(.catchall) { req in
            req.redirect(to: AppRoutes.root.absolute)
        }

        vaporApp.get(AppRoutes.root.path) { req in
            req.backgrounded {
                self.loadHome(req)
            }
        }

        vaporApp.get(AppRoutes.about.path) { req in
            req.backgrounded {
                self.loadAbout(req)
            }
        }

        vaporApp.get([AppRoutes.articles.path]) { req in
            req.backgrounded {
                self.loadArticleList(req)
            }
        }

        vaporApp.get([AppRoutes.articles.path, ":id"]) { req in
            req.backgrounded {
                self.loadArticle(req)
            }
        }
        
        vaporApp.get(["logs"]) { req in
            req.backgrounded {
                self.loadLogs(req)
            }
        }
    }

    private func loadHome(_ req: Request) -> Response {
        return baseRenderer.renderRouteWith {
            [.raw("Hello, world!")]
        }.asHtmlResponse
    }

    private func loadAbout(_ req: Request) -> Response {
        do {
            let aboutFile = rawFile(named: "about.md")
            let aboutContents = try String(contentsOf: aboutFile)
            let markdown = MarkdownParser.standard.parse(aboutContents)
            let aboutHtml = HtmlGenerator.standard.generate(doc: markdown)
            return baseRenderer.renderRouteWith{[
                .raw(aboutHtml)
            ]}.asHtmlResponse
        } catch {
            return req.redirect(to: AppRoutes.root.rawValue)
        }
    }

    private func loadArticleList(_ req: Request) -> Response {
        let orderedList = Node.ol(
            .fragment(
                articleLoader.currentArticles.map { article in
                    article.listItem
                }
            )
        )
        return baseRenderer.renderRouteWith {[
            orderedList
        ]}.asHtmlResponse
    }

    private func loadArticle(_ req: Request) -> Response {
        guard let id = req.parameters.get("id") else {
            return req.redirect(to: AppRoutes.root.rawValue)
        }
        let markdownHtml = articleRenderer.render(articleId: id)
        return baseRenderer.renderRouteWith {
            [.raw(markdownHtml)]
        }.asHtmlResponse
    }
    
    private func loadLogs(_ req: Request) -> Response {
        do {
            let logFile = LuLog.globalLogFile
            let logs = try String(contentsOf: logFile)
            let logBox = Node.textarea(
                attributes: [.style(safe:
"""
font-family: 'Courier New', monospace;
min-height: 1024px;
"""),
                ],
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

private extension Request {
    func backgrounded(
        _ operation: @escaping () throws -> Response
    ) -> EventLoopFuture<Response> {
        application.threadPool.runIfActive(eventLoop: eventLoop) {
            try operation()
        }
    }
}

private extension ArticleFile {
    private var articlePath: String {
        AppRoutes.articles.absolute + "/" + meta.id
    }

    var listItem: ChildOf<Tag.Ol> {
        .li([htmlLink])
    }

    var htmlLink: Node {
        .a(attributes: [.href(articlePath)], .span(.text(meta.name)))
    }
}

private extension String {
    var asHtmlResponse: Response {
        HTMLResponse.makeResponse(from: self)
    }
}

private class HTMLResponse {
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

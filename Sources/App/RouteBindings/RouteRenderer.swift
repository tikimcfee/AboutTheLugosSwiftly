import Vapor
import Html
import StylesData
import SharedAppTools
import MarkdownKit

public class VaporRouteRenderingContainer {

    let vaporApp: Vapor.Application

    lazy var sharedRenderer: HTMLRenderer = HTMLRenderer(vaporApp: vaporApp)
    lazy var sharedLoader: VaporArticleLoader = VaporArticleLoader()

    public init(vaporApp: Vapor.Application) {
        self.vaporApp = vaporApp
        configureServer()
        buildRoutes()
    }

    func configureServer() {
        generateAssets()
    }

    func generateAssets() {
        AppLog.trace("Generating assets...")
        do {
            try AssetWriter.writeAllAssets()
            AppLog.trace("Assets generated.")
        } catch {
            AppLog.error(error.localizedDescription)
        }
    }

    func buildRoutes() {
        vaporApp.middleware.use(
            FileMiddleware(publicDirectory: vaporApp.directory.publicDirectory)
        )

        vaporApp.get(.catchall) { req in
            req.redirect(to: AppRoutes.root.absolute)
        }
        
        let appRoutes: [AppRouteBuilderType] = [
            HomeRouteBuilder(baseRenderer: sharedRenderer),
            AboutRouteBuilder(baseRenderer: sharedRenderer),
            ArticleListRouteBuilder(baseRenderer: sharedRenderer, articleLoader: sharedLoader),
            ArticleRouteBuilder(baseRenderer: sharedRenderer, articleRenderer: ArticleRenderer(loader: sharedLoader)),
            #if DEBUG
            DebugLogRouteBuilder(baseRenderer: sharedRenderer)
            #endif
        ]
        
        appRoutes.forEach { builder in
            builder.attach(to: vaporApp)
        }
    }
}

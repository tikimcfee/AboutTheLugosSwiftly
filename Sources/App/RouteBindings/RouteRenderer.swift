import Vapor
import Html
import StylesData
import SharedAppTools

public class VaporRouteRenderingContainer {

    let vaporApp: Vapor.Application

    lazy var sharedRenderer: HTMLRenderer = HTMLRenderer(vaporApp: vaporApp)
    lazy var articleLoader: VaporArticleLoader = VaporArticleLoader(subDirectoryName: "articles")
    lazy var projectLoader: VaporArticleLoader = VaporArticleLoader(subDirectoryName: "projects")

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
            
            ArticleListRouteBuilder(baseRenderer: sharedRenderer, articleLoader: articleLoader),
            ArticleRouteBuilder(baseRenderer: sharedRenderer, articleRenderer: ArticleRenderer(loader: articleLoader)),
            
            ProjectListRouteBuilder(baseRenderer: sharedRenderer, projectLoader: projectLoader),
            ProjectRouteBuilder(baseRenderer: sharedRenderer, articleRenderer: ArticleRenderer(loader: projectLoader)),
            
            PrivacyRouteBuilder(baseRenderer: sharedRenderer)
        ]
        
        appRoutes.forEach { builder in
            builder.attach(to: vaporApp)
        }
        
//        #if DEBUG
//        DebugLogRouteBuilder(baseRenderer: sharedRenderer).attach(to: vaporApp)
//        #endif
    }
}

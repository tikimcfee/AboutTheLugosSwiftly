import Foundation
import Vapor
import SharedAppTools

class VaporArticleLoader {
    let vaporApp: Application
    
    lazy var component: ArticleLoaderComponent = {
        let root = rootSubDirectory(named: "articles")
        let comp = ArticleLoaderComponent(rootDirectory: root)
        comp.onLoadStart = { [weak vaporApp] in vaporApp?.logger.info("Articles refreshing") }
        comp.onLoadStop = { [weak vaporApp] in vaporApp?.logger.info("Article load complete") }
        comp.onLoadError = { [weak vaporApp] in vaporApp?.logger.report(error: $0) }
        return comp
    }()
    
    var currentArticles: [ArticleFile] { component.currentArticles }
    
    public subscript(_ id: String) -> ArticleFile? {
        get { component.articleLookup[id] }
    }
    
    init(vaporApp: Application) {
        self.vaporApp = vaporApp
        component.kickoffArticleLoading()
    }
}

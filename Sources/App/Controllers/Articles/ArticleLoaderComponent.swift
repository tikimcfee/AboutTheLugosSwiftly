import Foundation
import Vapor
import SharedAppTools

class VaporArticleLoader {
    let vaporApp: Application
    
    lazy var component: ArticleLoaderComponent = {
        let root = rootSubDirectory(named: "articles")
        let component = ArticleLoaderComponent(rootDirectory: root)
        component.handler = { [weak vaporApp] cycle in
            switch cycle {
            case .failure(let error):
                vaporApp?.logger.report(error: error)
            case .success:
                break
            }
        }
        return component
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

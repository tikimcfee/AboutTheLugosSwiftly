import Foundation
import Vapor
import SharedAppTools

class VaporArticleLoader {
    
    lazy var component: ArticleLoaderComponent = makeComponent()
    var currentArticles: [ArticleFile] { component.currentArticles }
        
    init() {
        component.kickoffArticleLoading()
    }
    
    public subscript(_ id: String) -> ArticleFile? {
        get { component.articleLookup[id] }
    }
}

extension VaporArticleLoader {
    private func makeComponent() -> ArticleLoaderComponent {
        let root = rootSubDirectory(named: "articles")
        let component = ArticleLoaderComponent(rootDirectory: root)
        component.handler = didRefresh(_:)
        return component
    }
    
    private func didRefresh(_ cycle: ArticleLoaderComponent.Cycle) {
        switch cycle {
        case .failure(let error):
            LuLog.error(error.localizedDescription)
        case .success:
            break
        }
    }
}

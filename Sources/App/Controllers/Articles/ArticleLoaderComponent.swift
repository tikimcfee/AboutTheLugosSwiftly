import Foundation
import Vapor
import SharedAppTools
import Combine

class VaporArticleLoader {
    let vaporApp: Application
    var cancellables = Set<AnyCancellable>()
    
    lazy var component: ArticleLoaderComponent = {
        let root = rootSubDirectory(named: "articles")
        let comp = ArticleLoaderComponent(rootDirectory: root)
        comp.$loadingError
            .receive(on: DispatchQueue.global())
            .compactMap { $0 }
            .sink { [weak vaporApp] error in vaporApp?.logger.report(error: error) }
            .store(in: &cancellables)
        
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

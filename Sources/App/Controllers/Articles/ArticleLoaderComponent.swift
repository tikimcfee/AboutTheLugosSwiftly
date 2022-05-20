import Foundation
import Vapor
import SharedAppTools

class VaporArticleLoader {
    let subDirectoryName: String
    lazy var component: ArticleLoaderComponent = makeComponent()
    var currentFiles: [ArticleFile] { component.currentArticles }
        
    init(subDirectoryName: String) {
        self.subDirectoryName = subDirectoryName
        component.kickoffArticleLoading()
    }
    
    public subscript(_ id: String) -> ArticleFile? {
        get { component.articleLookup[id] }
    }
}

extension VaporArticleLoader {
    private func makeComponent() -> ArticleLoaderComponent {
        let root = rootSubDirectory(named: subDirectoryName)
        let component = ArticleLoaderComponent(rootDirectory: root)
        component.handler = didRefresh(_:)
        return component
    }
    
    private func didRefresh(_ cycle: ArticleLoaderComponent.Cycle) {
        switch cycle {
        case .failure(let error):
            AppLog.error(error.localizedDescription)
        case .success:
            break
        }
    }
}

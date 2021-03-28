import Html
import SharedAppTools

extension ArticleFile {
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

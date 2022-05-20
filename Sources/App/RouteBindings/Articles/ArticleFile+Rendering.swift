import Html
import SharedAppTools

extension ArticleFile {
    func listItem(_ base: AppRoutes) -> ChildOf<Tag.Ol> {
        .li([htmlLink(base)])
    }
    
    func htmlLink(_ base: AppRoutes) -> Node {
        .a(attributes: [.href(articlePath(base))], .span(.text(meta.name)))
    }
    
    private func articlePath(_ base: AppRoutes) -> String {
        base.absolute + "/" + meta.id
    }
}

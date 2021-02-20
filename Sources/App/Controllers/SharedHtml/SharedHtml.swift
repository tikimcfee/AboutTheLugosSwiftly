import Foundation
import Html
import Vapor
import CSS
import StylesData

typealias NodesBuilder = () -> [Node]

struct HTMLRenderer {
    let vaporApp: Vapor.Application

    func renderRouteWith(builder: NodesBuilder) -> String {
        render(.html(
            sharedHead,
            renderContentWith(builder: builder)
        ))
    }

    private func renderContentWith(builder: NodesBuilder) -> ChildOf<Tag.Html> {
        .body([
            .div(attributes: [.class(RootNames.bodyContainer.rawValue)], [
                .div(attributes: [.class(BodyNames.navigationContainer.rawValue)],
                    .fragment(links)
                ),
                .div(
                    attributes: [.class(BodyNames.contentContainer.rawValue)],
                    .fragment(builder())
                )
            ])
        ])
    }

    private var links: [Node] {
        AppRoutes.displayRoutes.map {
            Node.a(attributes: [.href($0.absolute)], .span(.raw($0.description)))
        }
    }
}

import Foundation
import Html
import Vapor
import CSS
import StylesData
import SharedAppTools

typealias NodesBuilder = () -> [Node]

struct HTMLRenderer {
    let vaporApp: Vapor.Application
    let resourceLoader = CachingLoader()
    
    private var cssString: String {
        do {
            return try resourceLoader.resourceData(
                for: rootFile(named: "global.css")
            )
        } catch {
            LuLog.error(error.localizedDescription)
            return ""
        }
    }

    func renderRouteWith(builder: NodesBuilder) -> String {
        render(.html(
            .head(
                .meta(attributes: [
                    .init("name", "viewport"),
                    .content("width=device-width, initial-scale=1.0"),
                    .charset(.utf8)
                ]),
                .style(unsafe: cssString)
            ),
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

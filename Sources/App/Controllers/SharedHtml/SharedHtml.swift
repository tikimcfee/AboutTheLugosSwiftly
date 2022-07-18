import Foundation
import Html
import Vapor
import CSS
import StylesData
import SharedAppTools

typealias NodesBuilder = () -> [Node]

private extension HTMLRenderer {
    static let newCSSStylesheetLink = ChildOf<Tag.Head>.link(attributes: [
        .rel(.stylesheet),
        .href("/styles/lc_new.css")
    ])
}

struct HTMLRenderer {
    let vaporApp: Vapor.Application
    let resourceLoader = CachingLoader()
    
    private var cssString: String {
        do {
            return try resourceLoader.resourceData(
                for: rootFile(named: "global.css")
            )
        } catch {
            AppLog.error(error.localizedDescription)
            return ""
        }
    }

    func renderRouteWith(builder: NodesBuilder) -> String {
        let doctype = """
        <!DOCTYPE html>
        """
        return doctype + render(.html(
            .head(
                .meta(attributes: [
                    .init("name", "viewport"),
                    .content("width=device-width, initial-scale=1.0"),
                    .charset(.utf8)
                ]),
                Self.newCSSStylesheetLink
            ),
            renderContentWith(builder: builder)
        ))
    }

    private func renderContentWith(builder: NodesBuilder) -> ChildOf<Tag.Html> {
        .body([
            .div(attributes: [], [
                .nav(attributes: [],
                    .fragment(links)
                ),
                .div(
                    attributes: [],
                    .fragment(builder())
                )
            ])
        ])
    }

    private var links: [Node] {
        let linkNodes = AppRoutes.displayRoutes.map {
            Node.a(
                attributes: [
                    .href($0.absolute),
                    .style(safe: "padding: 1rem")
                ],
                .span(.raw($0.description))
            )
        }
        return linkNodes
    }
}

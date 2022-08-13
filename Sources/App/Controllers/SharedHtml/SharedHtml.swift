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
                .meta(
                    attributes: [
                        .init("name", "viewport"),
                        .content("width=device-width, initial-scale=1.0"),
                        .charset(.utf8)
                    ]
                ),
                Self.newCSSStylesheetLink
            ),
            renderContentWith(builder: builder)
        ))
    }

    private func renderContentWith(builder: NodesBuilder) -> ChildOf<Tag.Html> {
        .body([
            .header(
                attributes: [],
                .fragment(navigationLinksHeader)
            ),
            .div(
                attributes: [],
                .fragment(builder())
            ),
            .footer(
                attributes: [],
                .fragment(navigationLinksFooter)
            ),
        ])
    }

    private var navigationLinksHeader: [Node] {
        let linkNodes = AppRoutes.headerRoutes.map {
            Node.a(
                attributes: [
                    .href($0.absolute),
                ],
                .span(.raw($0.description))
            )
        }
        return linkNodes
    }
    
    private var navigationLinksFooter: [Node] {
        var linkNodes = endCapLinks
        var footerRoutes = AppRoutes.footerRoutes.map {
            Node.a(
                attributes: [
                    .href($0.absolute),
                ],
                .span(.raw($0.description))
            )
        }
        linkNodes.append(contentsOf: footerRoutes)
        return linkNodes
    }
    
    private var endCapLinks: [Node] { [
        Node.a(
            attributes: [
                .href("https://www.linkedin.com/in/ivanlugo/"),
            ],
            .span(.raw("📈 LinkedIn"))
        ),
        Node.a(
            attributes: [
                .href("https://twitter.com/FeeTiki"),
            ],
            .span(.raw("🐓 Twitter"))
        ),
        Node.a(
            attributes: [
                .href("https://calendly.com/thelugos/talk-with-ivan"),
            ],
            .span(.raw("📅 Chat Calendar"))
        )
    ] }
}

import Foundation
import Html
import Vapor

struct BaseRenderer {
    let vaporApp: Vapor.Application

    func renderRoute() -> String {
        var rootNode = Node.html(
            .head(
                .meta(attributes: [
                    .init("name", "viewport"),
                    .content("width=device-width, initial-scale=1.0"),
                    .charset(.utf8)
                ]),
                .link(attributes: [.href("global.css"), .rel(.stylesheet)])
//                .style(unsafe: globalCssData())
            ),
            .body(
                .div(
                    attributes: [.class("root-navigation-bar")],
                    .fragment(links)
                ),
                .div(
                    attributes: [.class("top-level-content-container")],
                    .fragment([
                        .text("Words go here!")
                    ])
                )
            )
        )
        return render(rootNode)
    }

    var links: [Node] {
        [
            .a(attributes: [.href("one")], .text("One")),
            .a(attributes: [.href("two")], .text("Two")),
            .a(attributes: [.href("three")], .text("Thr33ls")),
        ]
    }

    func globalCssData() -> String {
        do {
            let cssFile = rootFile(named: "global.css")
            return try String(contentsOf: cssFile)
        } catch {
            vaporApp.logger.report(error: error)
            return ""
        }
    }
}


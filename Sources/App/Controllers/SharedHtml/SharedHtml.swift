import Foundation
import Html
import Vapor

struct BaseRenderer {
    let vaporApp: Vapor.Application

    func renderRoute() -> String {
        let rootNode = Node.html(
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

protocol CSSClass {
    var rawValue: String { get }
}

enum Shared: String, CSSClass {
    case navigationBar = "shared-page-navigation-bar"
    case navigationLink = "shared-page-navigation-link"
}

enum Other: String, CSSClass {
    case aboutBody = "about-page-body"
    case aboutImage = "about-page-image"
}

extension Array where Element == CSSClass {
    var all: String {
        map { $0.rawValue }.joined(separator: ", ")
    }
}

let classes: String = [Shared.navigationBar, Shared.navigationLink, Other.aboutBody, Other.aboutImage].all

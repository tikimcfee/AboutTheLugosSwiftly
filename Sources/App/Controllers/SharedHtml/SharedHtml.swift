import Foundation
import Html
import Vapor
import CSS

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
			.body(attributes: [.class(Shared.pageBody.rawValue)], [
                .div(
					attributes: [.class(Shared.navigationBar.rawValue)],
                    .fragment(links)
                ),
                .div(
                    attributes: [.class("top-level-content-container")],
                    .fragment([
                        .text("Words go here!")
                    ])
                )
			])
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
	var block: () -> CSS { get }
}

extension CSSClass {
	var select: Select {
		Class(rawValue, block)
	}
}

enum Shared: String, CSSClass {
	case pageBody = "shared-page-body"
    case navigationBar = "shared-page-navigation-bar"
    case navigationLink = "shared-page-navigation-link"
	var block: () -> CSS {
		switch self {
			case .navigationBar: return {
				background(Color.hex(0xff0000))
			}
			case .navigationLink: return {
				background(Color.rgb(10, 10, 10,alpha: 10))
			}
			case .pageBody: return {
				width(.percent(67))
			}
		}
	}
}

//enum Other: String, CSSClass {
//    case aboutBody = "about-page-body"
//    case aboutImage = "about-page-image"
//}
//
//extension Array where Element == CSSClass {
//    var all: String {
//        map { $0.rawValue }.joined(separator: ", ")
//    }
//}


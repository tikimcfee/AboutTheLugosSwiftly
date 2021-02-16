import Foundation
import Html
import Vapor
import CSS

struct SharedPageComponentsRenderer {
    let vaporApp: Vapor.Application

    func renderRoute() -> String {
        let rootNode = Node.html(
            .head(
                .meta(attributes: [
                    .init("name", "viewport"),
                    .content("width=device-width, initial-scale=1.0"),
                    .charset(.utf8)
                ]),
//                .link(attributes: [.href("global.css"), .rel(.stylesheet)]),
                .style(unsafe: bodyCss.string())
            ),
            .body([
                .div(attributes: [.class(BodyNames.navigationContainer.rawValue)],
                    .fragment(links)
                ),
                .div(
                    attributes: [.class(BodyNames.contentContainer.rawValue)],
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
            .a(attributes: [.href("one")], .span("A First Link")),
            .a(attributes: [.href("two")], .span("A Second Link")),
            .a(attributes: [.href("three")], .span("A Third Link")),
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

struct ColorPalette {
    struct Root {
        static let siteBackground = Color.black
    }
    struct NavigationBar {
        static let background = Color.rgba(24, 24, 48, 1.0)
        static let linkText = Color.grey
        static let linkTextHover = Color.white
        static let linkTextVisited = Color.peachpuff
    }
    struct Content {
        static let background = Color.rgba(24, 48, 96, 1.0)
        static let text = Color.grey
    }
}

var sidebarHeightWide = CSSUnit.percent(100)
var sidebarWidthWide = CSSUnit.pixels(212)
var contentWidthWide = CSSUnit.percent(90)

var sidebarHeightThin = CSSUnit.auto
var sidebarWidthThin = CSSUnit.percent(100)
var contentWidthThin = CSSUnit.percent(100)

var bodyCss = Stylesheet {
    Html {
        height(.percent(100))
        width(.percent(100))
        margin(.pixels(0))
        padding(.pixels(0))

        font(.family("Arial"))
        color(.hex(0xCCCCCC))
    }

    Body {
        background(ColorPalette.Root.siteBackground)
        height(.percent(100))
        width(.percent(100))
        margin(.pixels(0))
        padding(.pixels(0))
    }

    Class(BodyNames.navigationContainer.rawValue) {
        background(ColorPalette.NavigationBar.background)
        height(sidebarHeightWide)
        width(sidebarWidthWide)
        margin(.pixels(0))
        padding(.pixels(0))
        position(.fixed)

        overflow(.auto)

        Anchor {
            color(ColorPalette.NavigationBar.linkText)
            display(.block)
            textDecoration(.none)
            margin(.pixels(8))
        }

        Anchor {
            color(ColorPalette.NavigationBar.linkTextHover)
            textDecoration(.underline)
        }.pseudo(.hover)

        Anchor {
            color(ColorPalette.NavigationBar.linkTextVisited)
        }.pseudo(.visited)
    }

    Class(BodyNames.contentContainer.rawValue) {
        margin([.left], sidebarWidthWide)
        padding(.pixels(8))

        background(ColorPalette.Content.background)
    }

    Group {
        Class(BodyNames.navigationContainer.rawValue) {
            width(sidebarWidthThin)
            height(sidebarHeightThin)
            position(.relative)
            Anchor {
                float(.left)
            }
        }
        Class(BodyNames.contentContainer.rawValue) {
            width(contentWidthThin)
            margin([.left], .pixels(0))
        }
    }.when(.screen, .maxWidth(.pixels(800)))
}

enum BodyNames: String, CSSClass, CaseIterable {
    case navigationContainer = "body-navigation-container"
    case contentContainer = "body-content-container"
    case root = "body-root"
}

enum NavigationBarNames: String, CSSClass, CaseIterable {
    case root = "navigation-bar-root"
    case link = "navigation-bar-link"
}

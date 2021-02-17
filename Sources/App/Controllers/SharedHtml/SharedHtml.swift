import Foundation
import Html
import Vapor
import CSS

typealias NodesBuilder = () -> [Node]

struct HTMLRenderer {
    let vaporApp: Vapor.Application

    func renderRouteWith(builder: NodesBuilder) -> String {
        render(.html(
            DefaultCaches.sharedHead,
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

private class DefaultCaches {
    static var sharedHead: ChildOf<Tag.Html> = {
        .head(
            .meta(attributes: [
                .init("name", "viewport"),
                .content("width=device-width, initial-scale=1.0"),
                .charset(.utf8)
            ]),
            .style(unsafe: sharedPageCss.string())
        )
    }()
    static var sharedPageCss: Stylesheet = {
        Stylesheet {
            Html {
                height(.percent(100))
                width(.percent(100))
                margin(.pixels(0))
                padding(.pixels(0))

                font(.family("Arial"))
                color(.hex(0xCCCCCC))
            }

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

            Body {
                background(ColorPalette.Root.siteBackground)
                height(.percent(100))
                width(.percent(100))
                margin(.pixels(0))
                padding(.pixels(0))
            }

            Class(RootNames.bodyContainer.rawValue) {
                padding(.pixels(8))
            }

            Class(BodyNames.navigationContainer.rawValue) {
                background(ColorPalette.NavigationBar.background)
                height(.percent(40))
                width(.pixels(196))
                margin(.pixels(0))
                padding(.pixels(0))
                position(.fixed)
            }

            Class(BodyNames.contentContainer.rawValue) {
                background(ColorPalette.Content.background)
                display(.flex)
                flexDirection(.column)
                margin([.left], .pixels(204))
                padding(.pixels(8))
            }

            Group {
                Class(RootNames.bodyContainer.rawValue) {
                    padding(.pixels(0))
                }
                Class(BodyNames.navigationContainer.rawValue) {
                    width(.percent(100))
                    height(.percent(8))
                    position(.relative)
                    Anchor {
                        float(.left)
                    }
                }
                Class(BodyNames.contentContainer.rawValue) {
                    margin([.left], .pixels(0))
                }
            }.when(.screen, .maxWidth(.pixels(800)))
        }
    }()
}

enum RootNames: String, CSSClass, CaseIterable {
    case bodyContainer = "root-body-container"
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

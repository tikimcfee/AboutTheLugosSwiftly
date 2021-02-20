import Html
import CSS
import Ink

public struct ColorPalette {
    public struct Root {
        public static let siteBackground = Color.black
        public static let text = Color.rgba(204, 204, 204, 1)
    }
    public struct NavigationBar {
        public static let background = Color.rgba(24, 48, 96, 1.0)
        public static let linkText = Color.peachpuff
        public static let linkTextHover = Color.white
        public static let linkTextVisited = Color.grey
    }
    public struct Content {
        public static let background = Color.rgba(24, 24, 48, 1.0)
        public static let text = Color.grey
        public static let preBody = Color.rgba(0, 0, 0, 0.66)
    }
}

public var sharedHead: ChildOf<Tag.Html> {
    .head(
        .meta(attributes: [
            .init("name", "viewport"),
            .content("width=device-width, initial-scale=1.0"),
            .charset(.utf8)
        ]),
        .link(attributes: [.href("/global.css"), .rel(.stylesheet)])
    )
}

public var sharedPageCss: Stylesheet {
    Stylesheet {
        Html {
            height(.percent(100))
            width(.percent(100))
            margin(.pixels(0))
            padding(.pixels(0))

            font(.family("Arial"))
            color(ColorPalette.Root.text)
        }

        Body {
            background(ColorPalette.Root.siteBackground)
            height(.percent(100))
            width(.percent(100))
            margin(.pixels(0))
            padding(.pixels(0))

            Preformatted {
                overflow(x: .auto)
                padding(.pixels(8))
                background(ColorPalette.Content.preBody)

                border(ColorPalette.Content.preBody, .pixels(2), .solid)
                borderRadius(.pixels(8))
            }
        }

        Anchor {
            color(ColorPalette.NavigationBar.linkText)
            textDecoration(.none)
        }

        Anchor {
            color(ColorPalette.NavigationBar.linkTextHover)
            textDecoration(.underline)
        }.pseudo(.hover)

        Anchor {
            color(ColorPalette.NavigationBar.linkTextVisited)
        }.pseudo(.visited)

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

            border(ColorPalette.NavigationBar.background, .pixels(2), .solid)
            borderRadius(.pixels(8))

            Anchor {
                display(.block)
                margin(.pixels(0))
                padding(.pixels(8))
            }
        }

        Class(BodyNames.contentContainer.rawValue) {
            background(ColorPalette.Content.background)
            display(.flex)
            flexDirection(.column)
            margin([.left], .pixels(208))
            padding(.pixels(8))

            border(ColorPalette.Content.background, .pixels(2), .solid)
            borderRadius(.pixels(8))
        }

        Group {
            Class(RootNames.bodyContainer.rawValue) {
                padding(.pixels(0))
            }
            Class(BodyNames.navigationContainer.rawValue) {
                width(.percent(100))
                height(.percent(8))
                position(.relative)
                border(ColorPalette.Content.background, .pixels(0), .none)
                borderRadius(.pixels(0))
                Anchor {
                    float(.left)
                }
            }
            Class(BodyNames.contentContainer.rawValue) {
                margin([.left], .pixels(0))
                borderRadius(.pixels(0))
            }
        }.when(.screen, .maxWidth(.pixels(800)))
    }
}

public enum RootNames: String, CSSClass, CaseIterable {
    case bodyContainer = "root-body-container"
}

public enum BodyNames: String, CSSClass, CaseIterable {
    case navigationContainer = "body-navigation-container"
    case contentContainer = "body-content-container"
    case root = "body-root"
}

public enum NavigationBarNames: String, CSSClass, CaseIterable {
    case root = "navigation-bar-root"
    case link = "navigation-bar-link"
}


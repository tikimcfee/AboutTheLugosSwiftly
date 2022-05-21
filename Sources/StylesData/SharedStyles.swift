import Html
import CSS
import SharedAppTools

public struct SiteStyling {
    static public var sharedPageCss: Stylesheet {
        Stylesheet {
            Html {
                height(.percent(100))
                width(.percent(100))
                margin(.pixels(0))
                padding(.pixels(0))

                font(.family("Tahoma"))
                color(ColorPalette.Root.text)
            }
            
            Divider {
                width(.percent(100))
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
            
            Paragraph {
                fontSize(.rem(0.87))
                lineHeight(.rem(1.2))
            }
            
            Heading(1) {
                margin([.top, .bottom], .pixels(4))
            }
            
            Heading(2) {
                margin([.top, .bottom], .pixels(4))
            }
            
            Anchor {
                color(ColorPalette.NavigationBar.linkText)
                textDecoration(.none)
            }

            Anchor {
                color(ColorPalette.NavigationBar.linkTextHover)
                textDecoration(.underline)
            }.pseudo(.hover)

            Class(RootNames.bodyContainer.rawValue) {
                padding(.pixels(8))
            }

            Class(BodyNames.navigationContainer.rawValue) {
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
                display(.block)
                
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
                
                Video {
                    width(.percent(100))
                }
            }.when(.screen, .maxWidth(.pixels(800)))
        }
    }
}

import CSS

public protocol CSSClass {
    var rawValue: String { get }
}

public extension Side {
    var prop: CSSProperty {
        switch self {
        case .top: return .top
        case .bottom: return .bottom
        case .left: return .left
        case .right: return .right
        }
    }
}

public enum Position: String {
    case absolute
    case relative
    case fixed
}

public struct Span: CSSSelector {
    public var selector = "span"
    public var children: [CSS] = []
    public init() { }
}

public struct Anchor: CSSSelector {
    public var selector = "a"
    public var children: [CSS] = []
    public init() { }
}


public struct Preformatted: CSSSelector {
    public var selector = "pre"
    public var children: [CSS] = []
    public init() { }
}

public extension CSSSelector {
    func webkitScrollbar() -> CSSSelector {
        Select(selector + "::-webkit-scrollbar", children)
    }
    func webkitScrollbarTrack() -> CSSSelector {
        Select(selector + "::-webkit-scrollbar-track", children)
    }
    func webkitScrollbarThumb() -> CSSSelector {
        Select(selector + "::-webkit-scrollbar-thumb", children)
    }
}


public func float(_ side: Side) -> Declaration {
    Declaration(property: .float, value: side.rawValue)
}

public func position(_ position: Position) -> Declaration {
    Declaration(property: .position , value: position.rawValue)
}

public func clearfixContent() -> Declaration {
    Declaration(property: .content , value: "")
}

public func borderBoxSizing() -> Declaration {
    Declaration(property: .boxSizing, value: "border-box")
}

public func sidePositioning(_ side: Side, _ amount: CSSUnit) -> Declaration {
    Declaration(property: side.prop, value: amount.description)
}

public func scrollbarWidth(_ amount: CSSUnit, _ keyword: String) -> Declaration {
    Declaration(property: .scrollbarWidth, value: keyword)
}

public func scrollbarColor(_ colorThumb: Color, _ colorTrack: Color) -> Declaration {
    Declaration(property: .scrollbarColor, value: "\(colorThumb.description) \(colorTrack.description)")
}

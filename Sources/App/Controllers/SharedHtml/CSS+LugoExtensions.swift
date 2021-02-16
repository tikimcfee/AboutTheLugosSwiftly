import Foundation
import CSS

protocol CSSClass {
    var rawValue: String { get }
}

extension Side {
    var prop: CSSProperty {
        switch self {
        case .top: return .top
        case .bottom: return .bottom
        case .left: return .left
        case .right: return .right
        }
    }
}

enum Position: String {
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

func float(_ side: Side) -> Declaration {
    Declaration(property: .float, value: side.rawValue)
}

func position(_ position: Position) -> Declaration {
    Declaration(property: .position , value: position.rawValue)
}

func clearfixContent() -> Declaration {
    Declaration(property: .content , value: "")
}

func borderBoxSizing() -> Declaration {
    Declaration(property: .boxSizing, value: "border-box")
}

func sidePositioning(_ side: Side, _ amount: CSSUnit) -> Declaration {
    Declaration(property: side.prop, value: amount.description)
}

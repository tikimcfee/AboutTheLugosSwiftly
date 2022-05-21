import CSS

public protocol CSSClass {
	var rawValue: String { get }
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

public struct ColorPalette {
	public struct Root {
		public static let siteBackground = Color.linen
		public static let text = Color.black
	}
	public struct NavigationBar {
		public static let background = Color.rgba(24, 48, 96, 1.0)
        public static let linkText = Color.hex(Int("db6700", radix: 16)!)
        public static let linkTextHover = Color.blue
		public static let linkTextVisited = Color.grey
	}
	public struct Content {
		public static let background = Color.rgba(24, 24, 48, 1.0)
        public static let text = Color.black
		public static let preBody = Color.rgba(0, 0, 0, 0.66)
	}
}

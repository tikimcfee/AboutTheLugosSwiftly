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

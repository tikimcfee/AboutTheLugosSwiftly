import Foundation
import Vapor

enum AppRoutes: String, CustomStringConvertible {
    case root = ""
    case about
    case articles
    case article
    case logs
    
    var path: PathComponent { .constant(rawValue) }
    var absolute: String { "/\(rawValue)" }
    
    var description: String {
        switch self {
        case .root:
            return "Home"
        case .about:
            return "About"
        case .article:
            return "Article"
        case .articles:
            return "Articles"
        case .logs:
            return "Server Logs"
        }
    }
    
    static var displayRoutes: [AppRoutes] {
        [.root, .about, .articles]
    }
}

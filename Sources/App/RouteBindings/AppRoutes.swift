import Foundation
import Vapor

enum AppRoutes: String, CustomStringConvertible {
    case root = ""
    case articles
    case article
    case logs
    
    var path: PathComponent { .constant(rawValue) }
    var absolute: String { "/\(rawValue)" }
    
    var description: String {
        switch self {
        // Single page
        case .root:
            return "Home"
        case .article:
            return "Article"
        case .logs:
            return "Server Logs"
        
        // Groups / subpages
        case .articles:
            return "Articles"
        
        }
    }
    
    static var displayRoutes: [AppRoutes] {
        [.root, .articles]
    }
}

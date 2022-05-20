import Foundation
import Vapor

enum AppRoutes: String, CustomStringConvertible {
    case root = ""
    case articles
    case article
    case logs
    
    case projects
    
    var path: PathComponent { .constant(rawValue) }
    var absolute: String { "/\(rawValue)" }
    
    var description: String {
        switch self {
        // Single page
        case .root:
            return "Home"
        case .article:
            return "Article"
        
        // Groups / subpages
        case .articles:
            return "Articles"
        case .projects:
            return "Projects"
            
        // Debug
        case .logs:
            return "Server Logs"
        }
    }
    
    static var displayRoutes: [AppRoutes] {
        [.root, .articles, .projects]
    }
}

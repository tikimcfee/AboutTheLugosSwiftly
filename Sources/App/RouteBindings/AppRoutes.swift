import Foundation
import Vapor

enum AppRoutes: String, CustomStringConvertible {
    case root = ""
    case articles
    case article
    case logs
    case privacyAndTerms
    
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
            
        // Raw Stuff
        case .privacyAndTerms:
            return "Privacy & Terms"
        
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
    
    static var headerRoutes: [AppRoutes] {
        [.root, .articles, .projects]
    }
    
    static var footerRoutes: [AppRoutes] {
        [.privacyAndTerms]
    }
}

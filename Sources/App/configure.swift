import Foundation
import Vapor

public func _Vapor_configure(_ app: Application) throws {
    // Serve files from /Public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))


    try _Vapor_routes(app)
}

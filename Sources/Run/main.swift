import App
import Vapor
import Logging
import SharedAppTools

var cliConfiguredEnvironment = try Environment.detect()
try LoggingSystem.bootstrap(from: &cliConfiguredEnvironment)

let _Vapor_app = Application(cliConfiguredEnvironment)

defer {
    _Vapor_app.shutdown()
}

let renderer = VaporRouteRenderingContainer(vaporApp: _Vapor_app)

try _Vapor_app.run()

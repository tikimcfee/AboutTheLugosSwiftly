import App
import Vapor

var cliConfiguredEnvironment = try Environment.detect()
try LoggingSystem.bootstrap(from: &cliConfiguredEnvironment)

let _Vapor_app = Application(cliConfiguredEnvironment)

defer {
    _Vapor_app.shutdown()
}

let renderer = VaporRouteRenderer(vaporApp: _Vapor_app)

try _Vapor_app.run()

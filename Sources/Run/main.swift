import App
import Vapor

var cliConfiguredEnvironment = try Environment.detect()
try LoggingSystem.bootstrap(from: &cliConfiguredEnvironment)

let _Vapor_app = Application(cliConfiguredEnvironment)

defer {
    _Vapor_app.shutdown()
}

try _Vapor_configure(_Vapor_app)
try _Vapor_app.run()

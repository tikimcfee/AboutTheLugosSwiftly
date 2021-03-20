import App
import Vapor
import Logging
import FileLogging
import SharedAppTools

var cliConfiguredEnvironment = try Environment.detect()

LoggingSystem.bootstrap { label in
    let logFile = rawFile(named: "applogs.txt")
    let fileLogger = try! FileLogging(to: logFile)
    return MultiplexLogHandler([
        ConsoleLogger(label: label, console: Terminal(), level: .trace),
        fileLogger.handler(label: label)
    ])
}

let _Vapor_app = Application(cliConfiguredEnvironment)

defer {
    _Vapor_app.shutdown()
}

let renderer = VaporRouteRenderingContainer(vaporApp: _Vapor_app)

try _Vapor_app.run()

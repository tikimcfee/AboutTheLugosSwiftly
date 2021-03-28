import App
import Vapor
import Logging
import SharedAppTools

// --- Logging Glue ---

private final class AppLogHandler: LogHandler {
    var metadata: Logger.Metadata = [:]
    var logLevel: Logger.Level = .trace
    
    subscript(metadataKey key: String) -> Logger.Metadata.Value? {
        get { metadata[key] }
        set(newValue) { metadata[key] = newValue }
    }
    
    func log(level: Logger.Level,
             message: Logger.Message,
             metadata: Logger.Metadata?,
             source: String, file: String, function: String, line: UInt) {
        let toLog = makeString(message, mergedMeta(from: metadata))
        switch level {
        case .trace: AppLog.trace(toLog)
        case .debug: AppLog.debug(toLog)
        case .error: AppLog.error(toLog)
        default: AppLog.external(toLog)
        }
    }
    
    func makeString(_ message: Logger.Message, _ meta: Logger.Metadata) -> String {
        "|| \(meta.debugDescription) || \(message)"
    }
    
    func mergedMeta(from newMeta: Logger.Metadata?) -> Logger.Metadata {
        guard let newMeta = newMeta else { return metadata }
        return metadata.merging(newMeta) { _, newKey in newKey }
    }
}


// ---

var cliConfiguredEnvironment = try Environment.detect()
LoggingSystem.bootstrap { label in
    MultiplexLogHandler([
        ConsoleLogger(label: label, console: Terminal()),
        AppLogHandler()
    ])
}

let _Vapor_app = Application(cliConfiguredEnvironment)

defer {
    _Vapor_app.shutdown()
}

let renderer = VaporRouteRenderingContainer(vaporApp: _Vapor_app)

try _Vapor_app.run()

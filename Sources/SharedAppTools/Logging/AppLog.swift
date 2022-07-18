import Foundation

public struct AppLog: CustomStringConvertible {
    enum Level: String { case trace, debug, error, external }
    
    let epochstamp: Double = Date().timeIntervalSince1970
    let message: String
    let level: Level
    
    public static func debug(_ message: @autoclosure () -> String) {
        AppLog(
            message: message(),
            level: .debug
        ).write()
    }
    
    public static func error(_ message: @autoclosure () -> String) {
        AppLog(
            message: message(),
            level: .error
        ).write()
    }
    
    public static func trace(_ message: @autoclosure () -> String) {
        AppLog(
            message: message(),
            level: .trace
        ).write()
    }
    
    public static func external(_ message: @autoclosure () -> String) {
        AppLog(
            message: message(),
            level: .external
        ).write()
    }
    
    public var description: String {
        "[applog-\(level.rawValue):\(String(format: "%.8f", epochstamp))]\t\(message)"
    }
}

public extension AppLog {
    private enum LogError: String, Error { case failedToWrite }
    static let globalLogFile = rawFile(named: "global.logs")
    private static let failedMessageLine = "Message decode failed!".data(using: .utf8)!
    
    private func write(_ file: URL = globalLogFile) {
        print(description)
        
//        do {
//            if !FileManager.default.fileExists(atPath: file.path) {
//                if !FileManager.default.createFile(atPath: file.path, contents: "".data(using: .utf8)) {
//                    throw LogError.failedToWrite
//                }
//            }
//            let data = description.data(using: .utf8)
//                ?? Self.failedMessageLine
//            try appendToFile(file, data)
//        } catch {
//            print(error)
//        }
    }
}

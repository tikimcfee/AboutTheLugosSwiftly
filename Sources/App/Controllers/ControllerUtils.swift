import Foundation


let jsonDecoder: JSONDecoder = {
    var decoder = JSONDecoder()
    return decoder
}()

// MARK: - File Operations
let fileManager = FileManager.default

var rootPublicResourceDirectory: URL {
    URL(fileURLWithPath: fileManager.currentDirectoryPath, isDirectory: true)
        .appendingPathComponent("Public")
}

func rootFile(named fileName: String) -> URL {
    rootPublicResourceDirectory.appendingPathComponent(fileName, isDirectory: false)
}

func rootSubDirectory(named directoryName: String) -> URL {
    rootPublicResourceDirectory.appendingPathComponent(directoryName, isDirectory: true)
}

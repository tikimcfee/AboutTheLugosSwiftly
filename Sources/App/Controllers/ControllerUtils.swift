import Foundation
import Ink

let jsonDecoder: JSONDecoder = {
    var decoder = JSONDecoder()
    return decoder
}()

let markdownParser = MarkdownParser()

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

extension URL {
    func defaultContents() throws -> [URL] {
        try fileManager.contentsOfDirectory(
            at: self,
            includingPropertiesForKeys: nil,
            options: .skipsHiddenFiles
        )
    }
}

// MARK: - Raw
func rawFile(named name: String) -> URL {
    rootSubDirectory(named: "raw")
        .appendingPathComponent(name)
}

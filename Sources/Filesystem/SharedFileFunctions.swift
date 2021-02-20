import Foundation

// MARK: - File Operations
public let fileManager = FileManager.default

public var rootPublicResourceDirectory: URL {
    URL(fileURLWithPath: fileManager.currentDirectoryPath, isDirectory: true)
        .appendingPathComponent("Public")
}

public func rootFile(named fileName: String) -> URL {
    rootPublicResourceDirectory.appendingPathComponent(fileName, isDirectory: false)
}

public func rootSubDirectory(named directoryName: String) -> URL {
    rootPublicResourceDirectory.appendingPathComponent(directoryName, isDirectory: true)
}

public extension URL {
    func defaultContents() throws -> [URL] {
        try fileManager.contentsOfDirectory(
            at: self,
            includingPropertiesForKeys: nil,
            options: .skipsHiddenFiles
        )
    }
}

// MARK: - Raw
public func rawFile(named name: String) -> URL {
    rootSubDirectory(named: "raw")
        .appendingPathComponent(name)
}


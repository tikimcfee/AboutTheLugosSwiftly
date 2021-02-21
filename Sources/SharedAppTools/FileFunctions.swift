import Foundation

// MARK: - File Operations
public let fileManager = FileManager.default

public var rootDirectory: URL {
    URL(fileURLWithPath: fileManager.currentDirectoryPath, isDirectory: true)
}

public var rootPublicResourceDirectory: URL {
    rootDirectory.appendingPathComponent("Public")
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

public func appendToFile(_ file: URL, _ data: Data) throws {
	let handle = try FileHandle(forUpdating: file)
	handle.seekToEndOfFile()
	handle.write(data)
	try handle.close()
}

// MARK: - I have no idea how to security
public struct PrivateFileHelper {
    public static var githubBearerToken: String {
        let bearerPath = rootDirectory
            .appendingPathComponent("Private")
            .appendingPathComponent("bearer")
        do {
            return try String(contentsOf: bearerPath)
        } catch {
            print(error)
            return ""
        }
    }
}

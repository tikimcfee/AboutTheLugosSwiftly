//
//  File.swift
//  
//
//  Created by Ivan Lugo on 3/1/21.
//

import Foundation

public struct ArticleCreator {
    
    public enum SaveError: Error {
        case invalidRoot(_ exists: Bool, _ isDirectory: Bool)
        case invalidMeta(_ property: String)
        case writeError(_ external: Error)
        case alreadyExists(_ path: String)
        case invalidBody(_ path: String)
        case articleFileCreationFailed
    }
    
    public enum DeleteError: Error {
        case invalidPath(_ exists: Bool, _ isDirectory: Bool)
        case inelegibleToDelete
    }

    public var rootDirectory: URL
    
    private let jsonEncoder = JSONEncoder()
    
    public init(rootDirectory: URL) {
        self.rootDirectory = rootDirectory
    }
    
    public func delete(article meta: ArticleMeta) throws {
        try assertCurrentState()
        
        let directory = meta.id
        let articleDirectory = rootDirectory.appendingPathComponent(directory, isDirectory: true)
        switch confirmExistingAt(url: articleDirectory, isDirectory: true) {
        case (true, true):
            break
        case let(exists, isDirectory):
            throw DeleteError.invalidPath(exists, isDirectory)
        }
        
        guard fileManager.isDeletableFile(atPath: articleDirectory.path) else {
            throw DeleteError.inelegibleToDelete
        }
        
        try fileManager.removeItem(at: articleDirectory)
    }
    
    public func createNew(article body: String, with meta: ArticleMeta) throws {
        try assertCurrentState()
        
        if let invalidProperty =
            meta.id.isEmpty ? "id empty" :
            meta.name.isEmpty ? "name empty" :
            meta.summary.isEmpty ? "summary empty" : nil {
            throw SaveError.invalidMeta(invalidProperty)
        }
        
        let newDirectoryName = meta.id
        let newArticleDirectory = rootDirectory.appendingPathComponent(newDirectoryName, isDirectory: true)
        guard !fileManager.fileExists(atPath: newArticleDirectory.path) else {
            throw SaveError.alreadyExists(newArticleDirectory.path)
        }
        
        try fileManager.createDirectory(at: newArticleDirectory,
                                        withIntermediateDirectories: false,
                                        attributes: nil)
        
        guard let stringData = body.data(using: .utf8) else {
            throw SaveError.invalidBody(body)
        }
        
        let articleDataPath = newArticleDirectory.appendingPathComponent("article.md").path
        guard fileManager.createFile(atPath: articleDataPath, contents: stringData) else {
            throw SaveError.articleFileCreationFailed
        }
        
        let metaPath = newArticleDirectory.appendingPathComponent("meta.json")
        let encodedMeta = try jsonEncoder.encode(meta)
        try encodedMeta.write(to: metaPath, options: .atomic)
    }
    
    private func assertCurrentState() throws {
        switch confirmExistingAt(url: rootDirectory, isDirectory: true) {
        case (true, true):
            break
        case let(exists, isDirectory):
            throw SaveError.invalidRoot(exists, isDirectory)
        }
    }
    
    private func confirmExistingAt(url: URL, isDirectory: Bool) -> (exists: Bool, isDirectory: Bool) {
        var isDirectory: ObjCBool = false
        let exists = fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory)
        return (exists, isDirectory.boolValue)
    }
}

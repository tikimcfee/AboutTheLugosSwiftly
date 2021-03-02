import Foundation

public class ArticleLoaderComponent: ObservableObject {
    private let loadingQueue: DispatchQueue
    private let loader = ArticleLoader()
    public var rootDirectory: URL {
        didSet { callAndSet() }
    }
    
    @Published public var currentArticles = ArticleList()
    @Published public var articleLookup = ArticleIndex()
    @Published public var loadingError: Error? = nil
    
    public init(rootDirectory: URL) {
        self.rootDirectory = rootDirectory
        self.loadingQueue = DispatchQueue(label: "ArticleLoader:\(rootDirectory.lastPathComponent)", qos: .background)
    }

    public func kickoffArticleLoading() {
        loadingQueue.async {
            self.refreshArticles()
        }
    }
    
    public func refreshArticles() {
        callAndSet()
        loadingQueue.asyncAfter(
            deadline: .now() + .seconds(60),
            execute: refreshArticles
        )
    }
    
    private func callAndSet() {
        do {
            try discoverArticles()
        } catch {
            loadingError = error
        }
    }
    
    private func discoverArticles() throws {
        var allArticles = ArticleList()
        var index = ArticleIndex()
        try allArticleDirectories().forEach { articleDirectory in
            try self.loader.sniff(articleDirectory, into: &allArticles, index: &index)
        }
        (currentArticles, articleLookup) = (allArticles, index)
    }
    
    private func allArticleDirectories() throws -> [URL] {
        try rootDirectory
            .defaultContents()
            .filter { $0.hasDirectoryPath }
    }
}

class ArticleLoader {
    public func sniff(_ directory: URL,
                       into list: inout ArticleList,
                       index: inout ArticleIndex) throws {
        var state = ArticleSniffState()
        for fileUrl in try directory.defaultContents() {
            guard !fileUrl.hasDirectoryPath else { continue }
            state.consume(url: fileUrl)
            if try append(to: &list, in: &index, from: state) {
                break
            }
        }
    }

    private func append(to list: inout [ArticleFile],
                        in index: inout [String: ArticleFile],
                        from state: ArticleSniffState) throws -> Bool {
        guard let file = try state.makeArticleFile() else {
            return false
        }
        list.append(file)
        index[file.meta.id] = file
        return true
    }
}

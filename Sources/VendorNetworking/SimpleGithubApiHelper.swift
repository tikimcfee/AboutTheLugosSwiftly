import Foundation

private let root = "https://api.github.com"
private let jsonDecoder = JSONDecoder()

private typealias JsonResponse = (Data?, URLResponse?, Error) -> Void

public typealias CommitsFetch = [CommitHandle]
public typealias CommitsFetchResult = Result<CommitsFetch, Error>
public typealias CommitsFetchClosure = (CommitsFetchResult) -> Void

public enum SimpleApiError: String, Error {
    case noDataInResponse
    case couldNotDecodeData
}

public struct CommitsFetchRequest: Codable {
    public let owner: String
    public let repo: String
    public let sha: String
    public let count: Int
    public init(owner: String,
                repo: String,
                sha: String,
                count: Int) {
        self.owner = owner
        self.repo = repo
        self.sha = sha
        self.count = count
    }
}

private extension CommitsFetchRequest {
    var asEndpointUrl: URL {
        let query = "?sha=\(sha)&per_page=\(count)"
        let commitsPath = "/repos/\(owner)/\(repo)/commits\(query)"
        return URL(string: "\(root)\(commitsPath)")!
    }
}

public struct GithubUserBlock: Codable {
    public let name: String
    public let email: String
    public let date: String
}

public struct Commit: Codable {
    public let author: GithubUserBlock
    public let committer: GithubUserBlock
    public let message: String?
}

public struct CommitHandle: Codable {
    public let sha: String
    public let comments_url: URL
    public let commit: Commit
}

public struct GithubApiHelper {
    public struct Config {
        let token: String

        public init(token: String) {
            self.token = token
        }
    }

    private let config: Config

    private var defaultHeader: [String: String] { [
        "Authorization": config.token,
        "Content-Type": "application/json",
        "Accept": "application/vnd.github.v3+json"
    ] }

    public init(config: Config) {
        self.config = config
    }

    public func fetchCommits(_ request: CommitsFetchRequest,
                      _ handler: @escaping CommitsFetchClosure) {
        let requestUrl = request.asEndpointUrl

        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = defaultHeader

        URLSession.shared.dataTask(with: request) {
            self.wrapRequest($0, $1, $2, handler)
        }.resume()
    }

    private func wrapRequest<T: Codable>(_ data: Data?,
                                         _ response: URLResponse?,
                                         _ error: Error?,
                                         _ done: (Result<T, Error>) -> Void) {
        do {
            if let error = error
                { throw error }
            guard let data = data else
                { throw SimpleApiError.noDataInResponse }

            let object = try jsonDecoder.decode(T.self, from: data)
            done(.success(object))
        } catch {
            done(.failure(error))
        }
    }
}

import Foundation

// Woah guys; Darwin split did some weird things
// https://github.com/SwiftyBeaver/SwiftyBeaver/commit/c81dcbcb3ca9ff70d8b4c0ca111bc10b39b43dca
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

let root = "https://api.github.com"
let jsonDecoder = JSONDecoder()

private typealias JsonResponse = (Data?, URLResponse?, Error) -> Void

public enum SimpleApiError: String, Error {
    case noDataInResponse
    case couldNotDecodeData
}

public struct GAHConfig {
    let token: String

    public init(token: String) {
        self.token = token
    }
}

public struct GithubApiHelper {

    private let config: GAHConfig

    private var defaultHeaderFields: [String: String] { [
        "Authorization": config.token,
        "Content-Type": "application/json",
        "Accept": "application/vnd.github.v3+json"
    ] }

    public init(config: GAHConfig) {
        self.config = config
    }

    public func fetchCommits(_ request: CommitsFetchRequest,
                             _ handler: @escaping CommitsFetchClosure) {
        var request = URLRequest(url: request.asEndpointUrl)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = defaultHeaderFields

        URLSession.shared.dataTask(with: request) {
            do {
                let decodedTuple: ([CommitHandle], Data) = try self.decodeJson($0, $1, $2)
                handler(.success(.init(handles: decodedTuple.0, source: decodedTuple.1)))
            } catch {
                handler(.failure(error))
            }
        }.resume()
    }

    private func decodeJson<T: Codable>(
        _ data: Data?,
        _ response: URLResponse?,
        _ error: Error?
    ) throws -> (T, Data) {
        if let error = error
            { throw error }
        guard let data = data else
            { throw SimpleApiError.noDataInResponse }

        return (try jsonDecoder.decode(T.self, from: data), data)
    }
}

import Foundation

public typealias CommitsFetch = FullCommitRequestResult
public typealias CommitsFetchResult = Result<CommitsFetch, Error>
public typealias CommitsFetchClosure = (CommitsFetchResult) -> Void

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

extension CommitsFetchRequest {
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

public struct FullCommitRequestResult {
    public let handles: [CommitHandle]
    public let source: Data
}

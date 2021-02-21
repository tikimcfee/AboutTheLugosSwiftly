import Foundation
import Html
import CSS
import StylesData
import SharedAppTools
import VendorNetworking
import Vapor

struct GitWidgetRenderer {
    let vaporApp: Vapor.Application

    func renderHUD() -> String {
        
        return ""
    }
}

class GitNetworkingStorageGlue {
    static var instance = GitNetworkingStorageGlue()

    lazy var helper: GithubApiHelper = {
        GithubApiHelper(
            config: GAHConfig(
                token: PrivateFileHelper.githubBearerToken
            )
        )
    }()

    lazy var defaultProjectRequest: CommitsFetchRequest = {
        CommitsFetchRequest(
            owner: "tikimcfee",
            repo: "AboutTheLugosSwiftly",
            sha: "master",
            count: 5
        )
    }()

    private var latestCommitsFile: URL {
        rawFile(named: "latest_commits")
    }

    private var fetchIsInProgress = false

    public func fetchAndWriteRecentCommits() {
        guard !fetchIsInProgress else { return }
        fetchIsInProgress.toggle()
        helper.fetchCommits(defaultProjectRequest) {
            switch $0 {
            case .success(let result):
                self.defaultProjectFetched(result)
            case .failure(let error):
                print(error)
            }
            self.fetchIsInProgress.toggle()
        }
    }

    public func readLocalCache() -> [CommitHandle] {
        do {
            let data = try Data(contentsOf: latestCommitsFile)
            let cachedHandles = try jsonDecoder.decode([CommitHandle].self, from: data)
            return cachedHandles
        } catch {
            print(error)
            return []
        }
    }

    private func defaultProjectFetched(_ defaultProject: CommitsFetch) {
        do {
            try defaultProject.source.write(to: latestCommitsFile)
        } catch {
            print(error)
        }
    }
}

extension CommitHandle {
    var markdownSummary: String {
"""
[Comments > \(commit.author.date)](\(comments_url))
```
\(commit.message ?? "<Missing commit message>")
```
"""
    }

}

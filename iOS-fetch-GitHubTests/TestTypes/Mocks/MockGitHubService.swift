//
//  MockGitHubService.swift
//  iOS-fetch-GitHubTests
//
//  Created by David Anglin on 10/9/20.
//

@testable import iOS_fetch_GitHub
import Foundation

class MockGitHubService: GitHubService {
    
    var getCommitsCallCount = 0
    var getCommitsDataTask = URLSession.shared.dataTask(with: URL(string: Constants.gitHubBaseURL)!)
    var getCommitsCompletion: (([Commits]?, Error?) -> Void)?
    
    func getCommits(completion: @escaping ([Commits]?, Error?) -> Void) -> URLSessionDataTask {
        getCommitsCallCount += 1
        getCommitsCompletion = completion
        return getCommitsDataTask
    }
}

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
    var getCommitsCompletion: (([CommitContainer]?, Error?) -> Void)?
    
    func getCommits(completion: @escaping ([CommitContainer]?, Error?) -> Void) {
        getCommitsCallCount += 1
        getCommitsCompletion = completion
    }
}

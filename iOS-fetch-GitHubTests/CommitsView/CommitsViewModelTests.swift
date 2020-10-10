//
//  CommitsViewModelTests.swift
//  iOS-fetch-GitHubTests
//
//  Created by David Anglin on 10/9/20.
//

@testable import iOS_fetch_GitHub
import XCTest

class CommitsViewModelTests: XCTestCase {
    
    var mockNetworkClient: MockGitHubService!
    var sut: CommitsViewModel!
    
    override func setUp() {
        super.setUp()
        mockNetworkClient = MockGitHubService()
        sut = CommitsViewModel(networkClient: mockNetworkClient)
    }
    
    func givenCommits(count: Int = 3) -> [Commits] {
      return (1 ... count).map { i in
        let commit = Commits(
            commitHash: "id_\(i)",
            commit: Commit(author: Author(name: "Bob_\(i)",
                                          email: "email_\(i)@gmail.com"),
                           message: "This is message: \(i)"))
        return commit
      }
    }
    
    func test_init_settingCommits() {
        let commits = givenCommits()
        sut.commits = commits
        XCTAssertEqual(sut.commits, commits)
    }
    
    func test_commitsUpdated() {
        let commitUpdatedExpectation = expectation(description: "Commits Updated")
        let commits = givenCommits()
        sut.commitsUpdated = commitUpdatedExpectation.fulfill

        sut.commits = commits
        waitForExpectations(timeout: 5.0)
    }
    
    func test_init_commitsAreEmpty() {
        XCTAssertTrue(sut.commits.isEmpty)
    }
    
    override func tearDown() {
        mockNetworkClient = nil
        sut = nil
        super.tearDown()
    }
}

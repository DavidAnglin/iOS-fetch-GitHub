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
    
    func givenCommits(count: Int = 3) -> [CommitContainer] {
      return (1 ... count).map { i in
        let commit = CommitContainer(
            commitHash: "id_\(i)",
            commit: Commit(author: Author(name: "Bob_\(i)",
                                          email: "email_\(i)@gmail.com"),
                           message: "This is message: \(i)"))
        return commit
      }
    }
    
    func test_init_viewModel() {
        XCTAssertNotNil(sut)
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
        waitForExpectations(timeout: 0.2)
    }
    
    func test_init_commitsAreEmpty() {
        XCTAssertTrue(sut.commits.isEmpty)
    }
    
    func test_error_populated() {
        let errorOccured = expectation(description: "Error")
        let error = NSError(domain: "com.CommitError", code: 30) as Error

        sut.errorOccured = { error in
            errorOccured.fulfill()
        }
        
        sut.errorOccured?(error)
        waitForExpectations(timeout: 5.0)
    }
    
    override func tearDown() {
        mockNetworkClient = nil
        sut = nil
        super.tearDown()
    }
}

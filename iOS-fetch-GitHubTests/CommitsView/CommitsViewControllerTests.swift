//
//  CommitsViewControllerTests.swift
//  iOS-fetch-GitHubTests
//
//  Created by David Anglin on 10/9/20.
//

@testable import iOS_fetch_GitHub
import XCTest

class CommitsViewControllerTests: XCTestCase {
    
    var viewModel: CommitsVMContract?
    var sut: CommitsViewController!
    
    override func setUp() {
        super.setUp()
        let viewModel = CommitsViewModel(networkClient: MockGitHubService())
        sut = CommitsViewController(viewModel: viewModel)
    }

    func testController_whenInitialized_tableViewIsSet() {
        sut.loadViewIfNeeded()
        XCTAssertNotNil(sut.tableView)
    }
    
    func testController_whenInitialized_titleIsSet() {
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.title, "Commits")
    }
    
    func testController_whenInitialized_withViewModel() {
        sut.loadViewIfNeeded()
        XCTAssertNotNil(sut.viewModel)
    }
    
    override func tearDown() {
        sut = nil
        viewModel = nil
        super.tearDown()
    }
}

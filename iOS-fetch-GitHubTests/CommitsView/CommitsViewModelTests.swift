//
//  CommitsViewModelTests.swift
//  iOS-fetch-GitHubTests
//
//  Created by David Anglin on 10/9/20.
//

import XCTest
@testable import iOS_fetch_GitHub

class CommitsViewModelTests: XCTestCase {

    func test_init_commitsAreEmpty() {
        let viewModel = CommitsViewModel()
        XCTAssertTrue(viewModel.commits.isEmpty)
    }
}

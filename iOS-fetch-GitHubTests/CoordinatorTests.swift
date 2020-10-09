//
//  CoordinatorTests.swift
//  iOS-fetch-GitHubTests
//
//  Created by David Anglin on 10/9/20.
//

import Foundation
import XCTest
@testable import iOS_fetch_GitHub

class CoordinatorTests: XCTest {
    
    func testCoordinator_whenInitialized() {
        let sut = MainCoordinator()
        XCTAssertTrue(sut.childControllers.isEmpty)
    }
}

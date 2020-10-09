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
    
    var sut: MainCoordinator!
    
    override func setUp() {
        super.setUp()
        let navigationController = UINavigationController()
        sut = MainCoordinator(navigationController: navigationController)
    }
    
    func testCoordinator_whenInitialized_childCoordinatorsIsEmpty() {
        XCTAssertTrue(sut.childCoordinators.isEmpty)
    }
    
    func testCoordinator_whenInitialized_navigationControllerInitted() {
        XCTAssertNotNil(sut.navigationController)
    }
    
    func testCoordinator_onStart_viewControllerInNavController() {
        XCTAssertTrue(sut.navigationController.viewControllers.count == 1)
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
}

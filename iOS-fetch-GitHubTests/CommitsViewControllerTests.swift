//
//  CommitsViewControllerTests.swift
//  iOS-fetch-GitHubTests
//
//  Created by David Anglin on 10/9/20.
//

import XCTest
@testable import iOS_fetch_GitHub

class CommitsViewControllerTests: XCTestCase {

    func testController_whenInitialized_coordinatorIsSet() {
        let navigationController = UINavigationController()
        let coordinator = MainCoordinator(navigationController: navigationController)
        coordinator.start()
        
        guard let commitsVC = coordinator.navigationController.viewControllers.first as? CommitsViewController else {
            XCTFail("Commits View Controller not in naviagtion stack")
            return
        }
        
        XCTAssertNotNil(commitsVC.coordinator)
    }
}

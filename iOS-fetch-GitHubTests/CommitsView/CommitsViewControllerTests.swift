//
//  CommitsViewControllerTests.swift
//  iOS-fetch-GitHubTests
//
//  Created by David Anglin on 10/9/20.
//

@testable import iOS_fetch_GitHub
import XCTest

class CommitsViewControllerTests: XCTestCase {
    
    var coordinator: MainCoordinator?
    var viewModel: CommitsVMContract?
    
    override func setUp() {
        let navigationController = UINavigationController()
        coordinator = MainCoordinator(navigationController: navigationController)
        coordinator?.start()
    }

    func testController_whenInitialized_coordinatorIsSet() {
        guard let commitsVC = coordinator?.navigationController.viewControllers.first as? CommitsViewController else {
            XCTFail("Commits View Controller not in naviagtion stack")
            return
        }
        
        XCTAssertNotNil(commitsVC.coordinator)
    }
    
    func testController_whenInitialized_viewModelIsSet() {
        guard let commitsVC = coordinator?.navigationController.viewControllers.first as? CommitsViewController else {
            XCTFail("Commits View Controller not in naviagtion stack")
            return
        }
        
        XCTAssertNotNil(commitsVC.viewModel)
    }
    
    override func tearDown() {
        coordinator = nil
        viewModel = nil
    }
}

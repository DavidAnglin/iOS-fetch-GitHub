//
//  MainCoordinator.swift
//  iOS-fetch-GitHub
//
//  Created by David Anglin on 10/9/20.
//

import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = CommitsViewModel(networkClient: GitHubClient.shared)
        let commitsVC = CommitsViewController(viewModel: viewModel)
        commitsVC.coordinator = self
        navigationController.pushViewController(commitsVC, animated: false)
    }
}

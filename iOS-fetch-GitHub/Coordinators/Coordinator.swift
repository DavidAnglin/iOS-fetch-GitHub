//
//  Coordinator.swift
//  iOS-fetch-GitHub
//
//  Created by David Anglin on 10/9/20.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController: UINavigationController { get set }
    
    func start()
}

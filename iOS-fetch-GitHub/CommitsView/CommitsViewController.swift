//
//  ViewController.swift
//  iOS-fetch-GitHub
//
//  Created by David Anglin on 10/9/20.
//

import UIKit

class CommitsViewController: UIViewController, Storyboard {
    
    // MARK: Properties
    weak var coordinator: MainCoordinator?
    var viewModel: CommitsVMContract?
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}


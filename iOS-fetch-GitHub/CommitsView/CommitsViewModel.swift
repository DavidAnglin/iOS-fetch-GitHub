//
//  CommitsViewModel.swift
//  iOS-fetch-GitHub
//
//  Created by David Anglin on 10/9/20.
//

import Foundation

protocol CommitsVMContract {
    var commits: [Commits] { get set }
    var commitsUpdated: () -> Void { get set }
}

class CommitsViewModel: CommitsVMContract {
    
    // MARK: Properties
    public var commits: [Commits] = [] {
        didSet {
            self.commitsUpdated()
        }
    }
    
    public var commitsUpdated: (() -> Void) = {}
    
    // MARK: Init
    
    init(networkClient: GitHubService) {
        networkClient.getCommits { [weak self] commits, error in
            guard error == nil, let unwrappedCommits = commits else {
                print("An error occured while fetching commits.")
                return
            }
            
            self?.commits = unwrappedCommits
        }
    }
}

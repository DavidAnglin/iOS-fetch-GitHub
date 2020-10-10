//
//  CommitsViewModel.swift
//  iOS-fetch-GitHub
//
//  Created by David Anglin on 10/9/20.
//

import Foundation

protocol CommitsVMContract {
    var commits: [CommitContainer] { get set }
    var commitsUpdated: () -> Void { get set }
    var errorOccured: ((_ error: Error?) -> Void)? { get set }
}

class CommitsViewModel: CommitsVMContract {
    
    // MARK: Properties
    public var commits: [CommitContainer] = [] {
        didSet {
            self.commitsUpdated()
        }
    }
    
    public var commitsUpdated: (() -> Void) = {}
    public var errorOccured: ((Error?) -> Void)?
    
    // MARK: Init
    
    init(networkClient: GitHubService) {
        networkClient.getCommits { [weak self] commits, error in
            guard error == nil, let unwrappedCommits = commits else {
                self?.errorOccured?(error)
                return
            }
            
            self?.commits = unwrappedCommits
        }
    }
}

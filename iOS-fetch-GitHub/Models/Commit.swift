//
//  Commit.swift
//  iOS-fetch-GitHub
//
//  Created by David Anglin on 10/9/20.
//

import Foundation

struct Commits: Decodable, Equatable {
    let commitHash: String
    let commit: Commit
    
    enum CodingKeys: String, CodingKey {
        case commitHash = "sha"
        case commit
    }
}

struct Commit: Decodable, Equatable {
    let author: Author
    let message: String
}

struct Author: Decodable, Equatable {
    let name: String
    let email: String
}

//
//  NetworkClient.swift
//  iOS-fetch-GitHub
//
//  Created by David Anglin on 10/9/20.
//

import Foundation

enum Constants {
    static let gitHubBaseURL = "https://api.github.com/repos/ReactiveX/RxSwift/"
}

protocol GitHubService {
    @discardableResult func getCommits(completion: @escaping ([Commits]?, Error?) -> Void) -> URLSessionDataTask
}

class GitHubClient: GitHubService {
    let baseURL: URL
    let session: URLSession
    let responseQueue: DispatchQueue?
    
    static let shared = GitHubClient(baseURL: URL(string: Constants.gitHubBaseURL)!,
                                     session: URLSession.shared,
                                     responseQueue: .main)
    
    init(baseURL: URL,
         session: URLSession,
         responseQueue: DispatchQueue?) {
        self.baseURL = baseURL
        self.session = session
        self.responseQueue = responseQueue
    }
    
    @discardableResult func getCommits(completion: @escaping ([Commits]?, Error?) -> Void) -> URLSessionDataTask {
        let url = URL(string: "commits", relativeTo: baseURL)!.absoluteURL
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            guard let strongSelf = self else { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200,
                  error == nil, let data = data else {
                strongSelf.dispatchResult(error: error, completion: completion)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let commits = try decoder.decode([Commits].self, from: data)
                strongSelf.dispatchResult(models: commits, completion: completion)
            } catch {
                strongSelf.dispatchResult(error: error, completion: completion)
            }
        }
        task.resume()
        return task
    }
    
    private func dispatchResult<Type>(
      models: Type? = nil,
      error: Error? = nil,
      completion: @escaping (Type?, Error?) -> Void) {
      guard let responseQueue = responseQueue else {
        completion(models, error)
        return
      }
      responseQueue.async {
        completion(models, error)
      }
    }
}

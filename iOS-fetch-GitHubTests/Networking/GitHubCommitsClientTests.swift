//
//  GitHubCommitsClientTests.swift
//  iOS-fetch-GitHubTests
//
//  Created by David Anglin on 10/9/20.
//

@testable import iOS_fetch_GitHub
import XCTest

class GitHubClientTests: XCTestCase {
    
    var sut: GitHubClient!
    var baseURL: URL!
    var mockSession: MockURLSession!
    
    var getCommitsURL: URL {
      return URL(string: "commits", relativeTo: baseURL)!
    }

    override func setUp() {
        super.setUp()
        baseURL = URL(string: "https://api.github.com/repos/ReactiveX/RxSwift/")!
        mockSession = MockURLSession()
        sut = GitHubClient(baseURL: baseURL, session: mockSession)
    }
    
    func test_init_sets_baseURL() {
        XCTAssertEqual(sut.baseURL, baseURL)
    }
    
    func test_init_sets_session() {
        XCTAssertEqual(sut.session, mockSession)
    }

    override func tearDown() {
        baseURL = nil
        mockSession = nil
        sut = nil
        super.tearDown()
    }
}

class MockURLSession: URLSession {

  var queue: DispatchQueue? = nil

  func givenDispatchQueue() {
    queue = DispatchQueue(label: "com.GitHubCommitsTests.MockSession")
  }

  override func dataTask(
    with url: URL,
    completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
      -> URLSessionDataTask {
        return mock(completionHandler: completionHandler,
                                      url: url,
                                      queue: queue)
  }
}

//class MockURLSessionDataTask: URLSessionDataTask {
//
//  var completionHandler: (Data?, URLResponse?, Error?) -> Void
//  var url: URL
//
//  init(completionHandler:
//    @escaping (Data?, URLResponse?, Error?) -> Void,
//       url: URL,
//       queue: DispatchQueue?) {
//    if let queue = queue {
//      self.completionHandler = { data, response, error in
//        queue.async() {
//          completionHandler(data, response, error)
//        }
//      }
//    } else {
//      self.completionHandler = completionHandler
//    }
//    self.url = url
//    super.init()
//  }
//
//  var calledResume = false
//  override func resume() {
//    calledResume = true
//  }
//}

class URLProtocolMock: URLProtocol {
    /// Dictionary maps URLs to tuples of error, data, and response
    static var mockURLs = [URL?: (error: Error?, data: Data?, response: HTTPURLResponse?)]()

    override class func canInit(with request: URLRequest) -> Bool {
        // Handle all types of requests
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        // Required to be implemented here. Just return what is passed
        return request
    }

    override func startLoading() {
        if let url = request.url {
            if let (error, data, response) = URLProtocolMock.mockURLs[url] {
                
                // We have a mock response specified so return it.
                if let responseStrong = response {
                    self.client?.urlProtocol(self, didReceive: responseStrong, cacheStoragePolicy: .notAllowed)
                }
                
                // We have mocked data specified so return it.
                if let dataStrong = data {
                    self.client?.urlProtocol(self, didLoad: dataStrong)
                }
                
                // We have a mocked error so return it.
                if let errorStrong = error {
                    self.client?.urlProtocol(self, didFailWithError: errorStrong)
                }
            }
        }

        // Send the signal that we are done returning our mock response
        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {
        // Required to be implemented. Do nothing here.
    }
}

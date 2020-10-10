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
    var mockSession: URLSession!
    
    var getCommitsURL: URL {
        return URL(string: "commits", relativeTo: baseURL)!.absoluteURL
    }

    override func setUp() {
        super.setUp()
        baseURL = URL(string: Constants.gitHubBaseURL)!
    }
    
    func setDefaultClient() {
        mockSession = URLSession.shared
        sut = GitHubClient(baseURL: baseURL, session: mockSession, responseQueue: nil)
    }
    
    func whenGetCommits(
      data: Data? = nil,
      statusCode: Int = 200,
      error: Error? = nil) ->
      (calledCompletion: Bool, commits: [Commits]?, error: Error?) {

        let response = HTTPURLResponse(url: getCommitsURL,
                                       statusCode: statusCode,
                                       httpVersion: nil,
                                       headerFields: nil)
        
        URLProtocolMock.mockURLs = [getCommitsURL: (error, data, response)]
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [URLProtocolMock.self]
        mockSession = URLSession(configuration: sessionConfiguration)
        sut = GitHubClient(baseURL: baseURL, session: mockSession, responseQueue: nil)
        
        var calledCompletion = false
        var receivedCommits: [Commits]? = nil
        var receivedError: Error? = nil
        
        let expectation = self.expectation(
          description: "Completion wasn't called")

        sut.getCommits { commits, error in
            calledCompletion = true
            receivedCommits = commits
            receivedError = error as NSError?
            expectation.fulfill()
        }
        
        // then
        waitForExpectations(timeout: 0.2)
        return (calledCompletion, receivedCommits, receivedError)
    }
    
    func test_shared_setsBaseURL() {
        // given
        let baseURL = URL(string: Constants.gitHubBaseURL)!

        // then
        XCTAssertEqual(GitHubClient.shared.baseURL, baseURL)
    }
    
    func test_shared_setsSession() {
        // given
        let session = URLSession.shared
        
        // then
        XCTAssertEqual(GitHubClient.shared.session, session)
    }
    
    func test_shared_setsResponseQueue() {
        // given
        let responseQueue = DispatchQueue.main
        
        // then
        XCTAssertEqual(GitHubClient.shared.responseQueue, responseQueue)
    }
    
    func test_init_sets_baseURL() {
        setDefaultClient()
        XCTAssertEqual(sut.baseURL, baseURL)
    }
    
    func test_init_sets_session() {
        setDefaultClient()
        XCTAssertEqual(sut.session, mockSession)
    }
    
    func test_getCommits_givenResponseCode500_callsCompletion() {
        // when
        let result = whenGetCommits(statusCode: 500)
        
        // then
        XCTAssertTrue(result.calledCompletion)
        XCTAssertNil(result.commits)
        XCTAssertNil(result.error)
    }
    
    func test_getCommits_givenValidJSON_callsCompletionWithCommits() {
        // given
        let data =
          try! Data.fromJSON(fileName: "GET_Commits_ValidResponse")

        let decoder = JSONDecoder()
        guard let commits = try? decoder.decode([Commits].self, from: data) else {
            XCTFail("Failed to decode commits!.")
            return
        }

        // when
        let result = whenGetCommits(data: data)

        // then
        XCTAssertTrue(result.calledCompletion)
        XCTAssertEqual(result.commits, commits)
        XCTAssertNil(result.error)
    }
    
    func test_getCommits_givenError_callsCompletionWithError() throws {
        // given
        let expectedError = NSError(domain: "com.GetCommitsTests", code: 42)
        
        // when
        let result = whenGetCommits(error: expectedError)
        
        // then
        XCTAssertTrue(result.calledCompletion)
        XCTAssertNil(result.commits)
        
        let actualError = try XCTUnwrap(result.error as NSError?)
        XCTAssertEqual(actualError.domain, expectedError.domain)
        XCTAssertEqual(actualError.code, expectedError.code)
    }
    
    func test_getDogs_givenInvalidJSON_callsCompletionWithError()
      throws {
        // given
        let data = try Data.fromJSON(
          fileName: "GET_Commits_MissingValues")

        var expectedError: NSError!
        let decoder = JSONDecoder()
        do {
          _ = try decoder.decode([Commits].self, from: data)
        } catch {
          expectedError = error as NSError
        }

        // when
        let result = whenGetCommits(data: data)

        // then
        XCTAssertTrue(result.calledCompletion)
        XCTAssertNil(result.commits)

        let actualError = try XCTUnwrap(result.error as NSError?)
        XCTAssertEqual(actualError.domain, expectedError.domain)
        XCTAssertEqual(actualError.code, expectedError.code)
    }
    
    func test_init_sets_responseQueue() {
        // given
        let responseQueue = DispatchQueue.main
        mockSession = URLSession.shared
        
        // when
        sut = GitHubClient(baseURL: baseURL,
                           session: mockSession,
                           responseQueue: responseQueue)
        
        // then
        XCTAssertEqual(sut.responseQueue, responseQueue)
    }
    
    func test_conformsTo_GitHubService() {
        setDefaultClient()
        XCTAssertTrue((sut as AnyObject) is GitHubService)
    }

    override func tearDown() {
        baseURL = nil
        mockSession = nil
        sut = nil
        super.tearDown()
    }
}

/// https://forums.raywenderlich.com/t/chapter-8-init-deprecated-in-ios-13/102050/8
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

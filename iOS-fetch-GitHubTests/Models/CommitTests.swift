//
//  CommitTests.swift
//  iOS-fetch-GitHubTests
//
//  Created by David Anglin on 10/9/20.
//

@testable import iOS_fetch_GitHub
import XCTest

class CommitTests: XCTestCase, DecodableTestCase {
    
    var dictionary: NSDictionary!
    var sut: CommitContainer!
    
    override func setUp() {
        super.setUp()
        try! givenSUTFromJSON()
    }
    
    override func tearDown() {
        dictionary = nil
        sut = nil
        super.tearDown()
    }
    
    func test_conformsTo_decodable() {
        XCTAssertTrue((sut as Any) is Decodable)
    }
    
    func test_conformsTo_Equatable() {
        XCTAssertEqual(sut, sut)
    }
    
    func test_decodable_commitHash() throws {
        try XCTAssertEqualToAny(sut.commitHash, dictionary["sha"])
    }
    
    func test_decodable_commitMessage() throws {
        guard let commit = dictionary["commit"] as? [String: Any] else {
            XCTFail("Coud not access commit.")
            return
        }
        try XCTAssertEqualToAny(sut.commit.message, commit["message"])
    }
    
    func test_decodable_commitAuthorName() throws {
        guard let commit = dictionary["commit"] as? [String: Any], let author = commit["author"] as? [String: String] else {
            XCTFail("Coud not access commit.")
            return
        }
        try XCTAssertEqualToAny(sut.commit.author.name, author["name"])
    }
    
    func test_decodable_commitAuthorEmail() throws {
        guard let commit = dictionary["commit"] as? [String: Any], let author = commit["author"] as? [String: String] else {
            XCTFail("Coud not access commit.")
            return
        }
        try XCTAssertEqualToAny(sut.commit.author.email, author["email"])
    }
}

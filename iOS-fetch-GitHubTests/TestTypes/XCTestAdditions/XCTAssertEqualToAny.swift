//
//  XCTAssertEqualToAny.swift
//  iOS-fetch-GitHubTests
//
//  Copyright (c) 2019 Razeware LLC
//  XCTAssertEqualToAny is used form Test Driven Development book by Ray Wenderlich

import XCTest

public func XCTAssertEqualToAny<T: Equatable>(_ actual: @autoclosure () throws -> T,
                                              _ expected: @autoclosure () throws -> Any?,
                                              file: StaticString = #file,
                                              line: UInt = #line) throws {
  let actual = try actual()
  let expected = try XCTUnwrap(expected() as? T)
  XCTAssertEqual(actual, expected, file: file, line: line)
}

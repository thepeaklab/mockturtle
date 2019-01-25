//
//  XCTestManifest.swift
//  AppTests
//
//  Created by Christoph Pageler on 25.01.19.
//


import XCTest


#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AppTests.allTests)
    ]
}
#endif

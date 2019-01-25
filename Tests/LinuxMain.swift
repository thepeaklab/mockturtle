//
//  LinuxMain.swift
//  LinuxMain
//
//  Created by Christoph Pageler on 24.01.19.
//


import XCTest
import MockturtleTests


var tests = [XCTestCaseEntry]()
tests += AppTests.allTests()
XCTMain(tests)

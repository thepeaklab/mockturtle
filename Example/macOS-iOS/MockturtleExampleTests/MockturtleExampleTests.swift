//
//  MockturtleExampleTests.swift
//  MockturtleExampleTests
//
//  Created by Christoph Pageler on 28.01.19.
//  Copyright © 2019 the peak lab. gmbh & co. kg. All rights reserved.
//


import XCTest
@testable import MockturtleExample


class MockturtleExampleTests: XCTestCase {

    func testAuthLoginWithDefaultSettingShouldSucceed() {
        let client = HTTPClient()
        client.environment = .test

        let authLoginExpectation = expectation(description: "auth login expectation")
        client.authLogin(username: "username", password: "password") { result in
            XCTAssertNotNil(result)
            XCTAssertEqual(result?.name, "Peter")
            XCTAssertEqual(result?.age, 19)
            authLoginExpectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testUsersWithDefaultSettingsShouldReturnTwoUsers() {
        let client = HTTPClient()
        client.environment = .test

        let usersExpectation = expectation(description: "users expectation")
        client.users { users in
            XCTAssertNotNil(users)
            XCTAssertEqual(users?.count, 2)
            usersExpectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testUsersWithEmptySettingShouldReturnNoUsers() {
        let client = HTTPClient()
        client.environment = .test
        client.mockturtleScenarioAdapter?.scenarioIdentifier = "all_valid_but_empty"

        let usersExpectation = expectation(description: "users expectation")
        client.users { users in
            XCTAssertNotNil(users)
            XCTAssertEqual(users?.count, 0)
            usersExpectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }

}

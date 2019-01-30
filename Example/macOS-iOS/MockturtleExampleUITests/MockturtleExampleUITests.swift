//
//  MockturtleExampleUITests.swift
//  MockturtleExampleUITests
//
//  Created by Christoph Pageler on 28.01.19.
//  Copyright © 2019 the peak lab. gmbh & co. kg. All rights reserved.
//


import XCTest


class MockturtleExampleUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    override func tearDown() { }

    func testAuthLoginWithDefaultSettingShouldShowUserNameInLabel() {
        let app = XCUIApplication()
        app.launch()

        app.buttons["Test"].tap()
        app.buttons["buttonSendLogin"].tap()

        let predicate = NSPredicate(format: "label = %@", "Hello Peter")
        let labelElement = app.staticTexts["labelResponse"]
        expectation(for: predicate,
                    evaluatedWith: labelElement,
                    handler: nil)

        waitForExpectations(timeout: 2, handler: nil)
    }

    func testAuthLoginWithInternalServerErrorShouldShowLoginError() {
        let app = XCUIApplication()
        app.launchEnvironment["MOCKTURTLE_SCENARIO_IDENTIFIER"] = "internal_server_error"
        app.launch()

        app.buttons["Test"].tap()
        app.buttons["buttonSendLogin"].tap()

        let predicate = NSPredicate(format: "label = %@", "Login Failed")
        let labelElement = app.staticTexts["labelResponse"]
        expectation(for: predicate,
                    evaluatedWith: labelElement,
                    handler: nil)

        waitForExpectations(timeout: 2, handler: nil)
    }

}

//
//  ViewController.swift
//  MockturtleExample
//
//  Created by Christoph Pageler on 28.01.19.
//  Copyright © 2019 the peak lab. gmbh & co. kg. All rights reserved.
//


import UIKit


class ViewController: UIViewController {

    private let httpClient = HTTPClient()
    @IBOutlet var segmentedControlEnvironment: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        updateSegmentedControlEnvironment()
    }

    @IBAction func actionEnvironmentDidChange(_ sender: UISegmentedControl) {
        switch segmentedControlEnvironment.selectedSegmentIndex {
        case 0: httpClient.environment = .test
        case 1: httpClient.environment = .stage
        case 2: httpClient.environment = .production
        default: break
        }
    }

    @IBAction func actionSendLoginTouchUpInside(_ sender: UIButton) {
        httpClient.authLogin(username: "username", password: "password") { loginResult in
            guard let loginResult = loginResult else {
                print("Login Failed")
                return
            }
            print("Hello \(loginResult.name)")
        }
    }

    private func updateSegmentedControlEnvironment() {
        switch httpClient.environment {
        case .test: segmentedControlEnvironment.selectedSegmentIndex = 0
        case .stage: segmentedControlEnvironment.selectedSegmentIndex = 1
        case .production: segmentedControlEnvironment.selectedSegmentIndex = 2
        }
    }

}


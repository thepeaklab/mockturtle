//
//  HTTPClient.swift
//  MockturtleExample
//
//  Created by Christoph Pageler on 28.01.19.
//  Copyright © 2019 the peak lab. gmbh & co. kg. All rights reserved.
//


import Foundation
import Alamofire
import Mockturtle


public class HTTPClient {

    public enum Environment {

        case test
        case stage
        case production

        public func baseURL() -> URL {
            switch self {
            case .test: return URL(string: "http://localhost:8080")!
            case .stage: return URL(string: "https://stage.api.example")!
            case .production: return URL(string: "https://stage.api.example")!
            }
        }
    }

    public var environment: Environment

    private let sessionManager: Alamofire.SessionManager

    public let mockturtleScenarioAdapter: MockturtleRequestAdapter?

    init() {
        self.environment = .production

        sessionManager = SessionManager.default

        // prepare adapter
        let defaultScenario = ProcessInfo.processInfo.environment["MOCKTURTLE_SCENARIO_IDENTIFIER"] ?? "all_valid"
        mockturtleScenarioAdapter = MockturtleRequestAdapter(defaultScenario)
        sessionManager.adapter = MasterAdapter(adapters: [mockturtleScenarioAdapter])
    }

    func foo() {
        let sessionManager = SessionManager.default
        sessionManager.adapter = MockturtleRequestAdapter("the_scenario_you_want_to_mock")
        sessionManager.request("<your url>")
    }

    public func authLogin(username: String, password: String, completion: @escaping (LoginDTO?) -> Void) {
        let authLoginURL = environment.baseURL().appendingPathComponent("/v1/auth/login")
        let parameters = [
            "username": username,
            "password": password
        ]
        sessionManager.request(authLoginURL, method: .post, parameters: parameters).responseData { response in
            switch response.result {
            case .success(let data):
                guard let loginResult = try? JSONDecoder().decode(LoginDTO.self, from: data) else {
                    completion(nil)
                    return
                }
                completion(loginResult)
            case .failure:
                completion(nil)
            }
        }
    }

    public func users(completion: @escaping ([UserDTO]?) -> Void) {
        let authLoginURL = environment.baseURL().appendingPathComponent("/v1/users")
        sessionManager.request(authLoginURL).responseData { response in
            switch response.result {
            case .success(let data):
                guard let userDTOS = try? JSONDecoder().decode([UserDTO].self, from: data) else {
                    completion(nil)
                    return
                }
                completion(userDTOS)
            case .failure:
                completion(nil)
            }
        }
    }

}


public extension HTTPClient {

    struct LoginDTO: Codable {

        let name: String
        let age: Int

    }

}


public extension HTTPClient {

    struct UserDTO: Codable {

        let name: String
        let age: Int

    }

}

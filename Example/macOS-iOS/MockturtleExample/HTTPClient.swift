//
//  HTTPClient.swift
//  MockturtleExample
//
//  Created by Christoph Pageler on 28.01.19.
//  Copyright © 2019 the peak lab. gmbh & co. kg. All rights reserved.
//


import Foundation
import Alamofire


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

    private let mockturtleScenarioAdapter: MockturtleScenarioAdapter

    init() {
        self.environment = .production

        sessionManager = SessionManager.default
        mockturtleScenarioAdapter = MockturtleScenarioAdapter()
        sessionManager.adapter = MasterAdapter(adapters: [mockturtleScenarioAdapter])
    }

    public func authLogin(username: String, password: String, completion: @escaping (LoginResult?) -> Void) {
        let authLoginURL = environment.baseURL().appendingPathComponent("/v1/auth/login")
        let parameters = [
            "username": username,
            "password": password
        ]
        sessionManager.request(authLoginURL, method: .post, parameters: parameters).responseData { response in
            switch response.result {
            case .success(let data):
                guard let loginResult = try? JSONDecoder().decode(LoginResult.self, from: data) else {
                    completion(nil)
                    return
                }
                completion(loginResult)
            case .failure:
                completion(nil)
            }
        }
    }

}


public extension HTTPClient {

    struct LoginResult: Codable {

        let name: String
        let age: Int

    }

}


public class MockturtleScenarioAdapter: RequestAdapter {

    public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        return urlRequest
    }

}

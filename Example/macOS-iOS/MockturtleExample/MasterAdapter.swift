//
//  MasterAdapter.swift
//  MockturtleExample
//
//  Created by Christoph Pageler on 28.01.19.
//  Copyright © 2019 the peak lab. gmbh & co. kg. All rights reserved.
//


import Foundation
import Alamofire


// allows to use multiple adapters
// see https://stackoverflow.com/a/50970589/5283648
public struct MasterAdapter: RequestAdapter {

    public let adapters: [RequestAdapter?]

    public init(adapters: [RequestAdapter?]) {
        self.adapters = adapters
    }

    public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var request = urlRequest
        try adapters.compactMap({ $0 }).forEach({ request = try $0.adapt(request) })
        return request
    }

}

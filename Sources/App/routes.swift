//
//  routes.swift
//  App
//
//  Created by Christoph Pageler on 13.11.18.
//


import Vapor


public func routes(_ router: Router) throws {

    let responseController = try ResponseController()

    // register catch all route for all methods
    let httpMethods: [HTTPMethod] = [
        .GET, .PUT, .ACL, .HEAD, .POST, .COPY, .LOCK, .MOVE, .BIND, .LINK, .PATCH, .TRACE, .MKCOL, .MERGE, .PURGE,
        .NOTIFY, .SEARCH, .UNLOCK, .REBIND, .UNBIND, .REPORT, .DELETE, .UNLINK, .CONNECT, .MSEARCH, .OPTIONS,
        .PROPFIND, .CHECKOUT, .PROPPATCH, .SUBSCRIBE, .MKCALENDAR, .MKACTIVITY, .UNSUBSCRIBE, .TRACE
    ]
    for httpMethod in httpMethods {
        router.on(httpMethod, at: PathComponent.catchall, use: responseController.dynamicResponse)
    }

}

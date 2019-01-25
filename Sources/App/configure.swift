//
//  configure.swift
//  App
//
//  Created by Christoph Pageler on 13.11.18.
//


import Vapor


public func configure(_ config: inout Config,
                      _ env: inout Environment,
                      _ services: inout Services) throws {

    // Router
    if !env.arguments.contains("generateScenarioFile") {
        let router = EngineRouter.default()
        try routes(router)
        services.register(router, as: Router.self)
    }

    // Register middleware
    var middlewares = MiddlewareConfig()
    middlewares.use(ErrorMiddleware.self)
    services.register(middlewares)

    // Commands
    var commandConfig = CommandConfig.default()
    commandConfig.use(GenerateScenarioFileCommand(), as: "generateScenarioFile")
    services.register(commandConfig)

}

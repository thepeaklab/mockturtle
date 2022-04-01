//
//  configure.swift
//  App
//
//  Created by Christoph Pageler on 13.11.18.
//


import Vapor


public func configure(_ app: Application) throws {
    app.commands.use(GenerateScenarioFileCommand(), as: "generateScenarioFile")
    try routes(app)
}

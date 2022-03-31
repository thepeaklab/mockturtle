//
//  main.swift
//  Run
//
//  Created by Christoph Pageler on 16.11.18.
//


import App
import Vapor

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
defer { app.shutdown() }
try configure(app)
try app.run()

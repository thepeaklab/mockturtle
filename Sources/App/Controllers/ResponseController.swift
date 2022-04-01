//
//  ResponseController.swift
//  App
//
//  Created by Christoph Pageler on 13.11.18.
//


import Foundation
import Vapor
import MockturtleParser


final class ResponseController {

    private var configPath: URL
    private var mockturtleConfig: MockturtleConfig
    private var mockturtleLogger: MockturtleLogger
    private var logLevel: MockturtleLogger.Level
    private var configWatch: ConfigWatch

    private let configPathResolver = ConfigPathResolver()

    public init() throws {
        let configPath = try configPathResolver.resolveConfigPath()

        let logLevelString = ProcessInfo.processInfo.environment["LOGLEVEL"] ?? "INFO"
        let logLevel = MockturtleLogger.Level(parameter: logLevelString) ?? .info
        self.logLevel = logLevel
        print("Mockturtle started, Log Level: \(logLevel)")

        mockturtleLogger = MockturtleLogger { (message, level) in
            if level >= logLevel {
                switch level {
                case .verbose:  print("VERBOSE : \(message)")
                case .info:     print("INFO    : \(message)")
                case .warning:  print("WARNING : \(message)")
                case .error:    print("ERROR   : \(message)")
                }
            }
        }
        let configFileURL = URL(fileURLWithPath: configPath)
        self.configPath = configFileURL
        guard let mockturtleConfig = MockturtleConfig.load(contentsOf: configFileURL,
                                                           logger: mockturtleLogger)
        else {
            throw Abort(.internalServerError, reason: "Failed to load config: see logs")
        }
        self.mockturtleConfig = mockturtleConfig
        self.configWatch = ConfigWatch(configFile: configFileURL)
        self.configWatch.delegate = self
    }

    private func reloadConfig() {
        print("reload config")
    }

    func dynamicResponse(_ req: Request) throws -> EventLoopFuture<Response> {
        let stateIdentifier = req.headers["x-mockturtle-state-identifier"].first
        guard let route = mockturtleConfig.route(for: req.url.path,
                                                 method: req.method,
                                                 stateIdentifier: stateIdentifier)
        else {
            throw Abort(.notFound, reason: "no route found for `\(req.method.string): \(req.url.path)`")
        }
        guard let state = route.state(for: stateIdentifier) else {
            if let stateIdentifier = stateIdentifier {
                throw Abort(.notFound, reason: "no state found for identifier `\(stateIdentifier)`")
            } else {
                // swiftlint:disable line_length
                throw Abort(.notFound, reason: "x-mockturtle-state-identifier not set and no or too states many found for route `\(req.method.string): \(req.url.path)`")
                // swiftlint:enable line_lengt
            }
        }

        let httpResponse = Response(status: HTTPResponseStatus(statusCode: state.response.code),
                                    headers: HTTPHeaders(state.response.header.map{ ($0, $1) }),
                                    body: .init(string: state.response.body ?? ""))

        let responsePromise = req.eventLoop.makePromise(of: Response.self)

        var delayInSeconds: Double = 0.0
        if let delay = state.delay {
            let msFrom = Int(delay.from * 1000)
            let msTo = Int(delay.to * 1000)
            let delayInMilliseconds = Int.random(in: msFrom...msTo)
            delayInSeconds = Double(delayInMilliseconds) / 1000
            httpResponse.headers.add(name: "x-mockturtle-delay-in-ms", value: "\(delayInMilliseconds)")
        }

        DispatchQueue.global(qos: .default).asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
            responsePromise.succeed(httpResponse)
        }

        return responsePromise.futureResult
    }

}

extension ResponseController: ConfigWatchDelegate {

    func configWatch(_ configWatch: ConfigWatch, didRecognizeChangesInFilesAt urls: [URL]) {
        let baseURL = configPath.deletingLastPathComponent()
        let fileChangesList = urls
            .map({ "- \($0.path.replacingOccurrences(of: baseURL.path, with: ""))" })
            .joined(separator: "\n")
        print("detected file changes in:\n\(fileChangesList)")
        print("reload config")

        guard let mockturtleConfig = MockturtleConfig.load(contentsOf: configPath, logger: self.mockturtleLogger) else {
            print("failed to reload config")
            return
        }
        self.mockturtleConfig = mockturtleConfig
        self.configWatch = ConfigWatch(configFile: configPath)
        self.configWatch.delegate = self
    }

}


fileprivate extension MockturtleConfig {

    func route(for path: String,
               method: HTTPMethod,
               stateIdentifier: String?) -> MockturtleRoute? {
        // check if there are global routes without url
        // global routes are only valid when called with state identifier
        if let stateIdentifier = stateIdentifier {
            for route in routes.filter({ $0.url == nil }) {
                if route.state(for: stateIdentifier) != nil {
                    return route
                }
            }
        }

        // check routes by path and method
        return routes.first(where: { $0.matches(with: path, method: method) })
    }

}


fileprivate extension MockturtleRoute {

    func matches(with checkPath: String, method: HTTPMethod) -> Bool {
        guard var url = url else { return false }
        // append / prefix
        if !url.hasPrefix("/") { url = "/\(url)" }

        // check equal path
        guard checkPath == url else { return false }

        // check if route is limited to a certain method
        if let stringMethod = self.method {
            if stringMethod != method.string {
                return false
            }
        }

        return true
    }

    func state(for identifier: String?) -> MockturtleState? {
        if identifier == nil && states?.count == 1 {
            return states?.first
        }
        return states?.first(where: { $0 == identifier })
    }

}


fileprivate extension MockturtleLogger.Level {

    init?(parameter: String) {
        switch parameter {
        case "VERBOSE": self = .verbose
        case "INFO": self = .info
        case "WARNING": self = .warning
        case "ERROR": self = .error
        default: return nil
        }
    }

    static func >= (lhs: MockturtleLogger.Level, rhs: MockturtleLogger.Level) -> Bool {
        switch lhs {
        case .verbose:  return rhs == .verbose
        case .info:     return rhs == .verbose || rhs == .info
        case .warning:  return rhs == .verbose || rhs == .info || rhs == .warning
        case .error:    return rhs == .verbose || rhs == .info || rhs == .warning || rhs == .error
        }
    }

}

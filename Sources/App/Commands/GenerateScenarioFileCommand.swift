//
//  GenerateScenarioFileCommand.swift
//  App
//
//  Created by Christoph Pageler on 16.11.18.
//


import Vapor
import MockturtleParser


struct GenerateScenarioFileCommand: Command {

    var arguments: [CommandArgument] {
        return []
    }

    var options: [CommandOption] {
        return [
            .value(name: "folder",
                   short: "f",
                   default: nil,
                   help: [
                    "Folder"
                   ]),
            .value(name: "output-file",
                   short: "o",
                   default: nil,
                   help: [
                    "Folder"
                   ])
        ]
    }

    var help: [String] {
        return [
            "Aint nobody need help"
        ]
    }

    func run(using context: CommandContext) throws -> EventLoopFuture<Void> {
        guard let folder = context.options["folder"] else {
            print("folder not set")
            return context.container.eventLoop.newSucceededFuture(result: ())
        }
        var folderIsDirectory: ObjCBool = false
        guard FileManager.default.fileExists(atPath: folder, isDirectory: &folderIsDirectory) else {
            print("folder not found")
            return context.container.eventLoop.newSucceededFuture(result: ())
        }
        guard folderIsDirectory.boolValue else {
            print("folder is not a directory")
            return context.container.eventLoop.newSucceededFuture(result: ())
        }

        guard let outputFile = context.options["output-file"] else {
            print("output-file not set")
            return context.container.eventLoop.newSucceededFuture(result: ())
        }

        let logger = MockturtleLogger { (message, level) in
            switch level {
            case .verbose:  print("VERBOSE : \(message)")
            case .info:     print("INFO    : \(message)")
            case .warning:  print("WARNING : \(message)")
            case .error:    print("ERROR   : \(message)")
            }
        }
        guard let scenarios = MockturtleScenario.load(directoryOf: URL(fileURLWithPath: folder), logger: logger) else {
            print("failed to parse scenarios")
            return context.container.eventLoop.newSucceededFuture(result: ())
        }

        let output = MockturtleScenarioOutput(scenarios: scenarios)
        guard let jsonOutput = try? JSONEncoder().encode(output) else {
            print("failed to generate scenario output")
            return context.container.eventLoop.newSucceededFuture(result: ())
        }

        do {
            try jsonOutput.write(to: URL(fileURLWithPath: outputFile))
            print("did write scenario output to \(outputFile)")
        } catch {
            print("failed to write output-file at \(outputFile)")
            return context.container.eventLoop.newSucceededFuture(result: ())
        }

        return context.container.eventLoop.newSucceededFuture(result: ())
    }
}


private class MockturtleScenarioOutput: Codable {

    var scenarios: [String: MockturtleFlattenedScenario]

    init(scenarios: [MockturtleScenario]) {
        self.scenarios = [:]
        for scenario in scenarios {
            guard let identifier = scenario.identifier else { continue }
            self.scenarios[identifier] = MockturtleFlattenedScenario(scenario: scenario)
        }
    }

    class MockturtleFlattenedScenario: Codable {

        public var routes: [MockturtleScenario.Route]

        init(scenario: MockturtleScenario) {
            self.routes = scenario.flatRoutes()
        }

    }

}

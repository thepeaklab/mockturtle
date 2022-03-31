//
//  GenerateScenarioFileCommand.swift
//  App
//
//  Created by Christoph Pageler on 16.11.18.
//


import Vapor
import MockturtleParser


struct GenerateScenarioFileCommand: Command {

    var help: String = "Aint nobody need help"

    struct Signature: CommandSignature {
        @Option(name: "output-file", short: "o")
        var outputFile: String?

        @Option(name: "folder", short: "f")
        var folder: String?
    }

    func run(using context: CommandContext, signature: Signature) throws {
        return
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

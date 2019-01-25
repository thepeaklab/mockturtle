//
//  ConfigPathResolver.swift
//  App
//
//  Created by Christoph Pageler on 25.01.19.
//


import Foundation


public class ConfigPathResolver {

    public func resolveConfigPath() throws -> String {
        // ENV[CONFIG]
        if let configEnv = ProcessInfo.processInfo.environment["CONFIG"] {
            return configEnv
        }

        // working_directory/mock-config.yml
        let workingDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let workingDirectoryConfigPath = workingDirectoryURL.appendingPathComponent("mock-config.yml").path
        if FileManager.default.fileExists(atPath: workingDirectoryConfigPath) {
            return workingDirectoryConfigPath
        }

        throw ConfigPathResolverError.couldNotResolveConfigPath
    }

}


public enum ConfigPathResolverError: Error {

    case couldNotResolveConfigPath

}

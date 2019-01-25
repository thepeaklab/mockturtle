//
//  ConfigWatch.swift
//  App
//
//  Created by Christoph Pageler on 14.11.18.
//


import Foundation
import CoreFoundation
import Crypto
import MockturtleParser


public protocol ConfigWatchDelegate: class {

    func configWatch(_ configWatch: ConfigWatch, didRecognizeChangesInFilesAt urls: [URL])

}


public class ConfigWatch {

    private let configFile: URL
    public weak var delegate: ConfigWatchDelegate?

    private var timer: DispatchSourceTimer?

    private var fileHashes: [URL: String]

    init(configFile: URL) {
        self.configFile = configFile
        self.fileHashes = [:]

        reloadHashes(fireDelegate: false)

        let queue = DispatchQueue(label: "com.thepeaklab.mockturtle.configwatch.timer")
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer?.schedule(deadline: .now(), repeating: 2.0, leeway: .seconds(0))
        timer?.setEventHandler { [weak self] in
            self?.reloadHashes()
        }
        timer?.resume()
    }

    private func reloadHashes(fireDelegate: Bool = true) {
        guard let newHashes = fileHashedForConfigFile() else { return }
        if newHashes == fileHashes { return }

        var updatedFiles: [URL] = []
        for newHash in newHashes {
            if let oldHash = fileHashes[newHash.key] {
                if oldHash != newHash.value {
                    updatedFiles.append(newHash.key)
                }
            } else {
                updatedFiles.append(newHash.key)
            }
        }

        if fireDelegate && updatedFiles.count > 0 {
            delegate?.configWatch(self, didRecognizeChangesInFilesAt: updatedFiles)
        }

        fileHashes = newHashes
    }

    private func fileHashedForConfigFile() -> [URL: String]? {
        guard let configFileHash = hashForFile(at: configFile) else { return nil }
        var hashes: [URL: String] = [:]
        hashes[configFile] = configFileHash
        let baseDirectory = configFile.deletingLastPathComponent()

        if let config = MockturtleConfig.load(contentsOf: configFile) {
            for route in config.routes {
                guard let routeDirectory = route.resolvedDirectory(baseDirectory: baseDirectory) else { continue }
                let files = try? FileManager.default.contentsOfDirectory(at: routeDirectory,
                                                                         includingPropertiesForKeys: nil,
                                                                         options: [])
                for file in files ?? [] {
                    guard file.pathExtension == "yml" else { continue }
                    let fileHash = hashForFile(at: file)
                    hashes[file] = fileHash
                }
            }
        }

        return hashes
    }

    private func hashForFile(at url: URL) -> String? {
        guard let data = try? Data(contentsOf: url) else { return nil }
        guard let hashData = try? SHA256.hash(data) else { return nil }
        return hashData.map { String(format: "%02hhx", $0) }.joined()
    }

}

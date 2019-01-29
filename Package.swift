// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "Mockturtle",
    dependencies: [
        .package(url: "https://github.com/vapor/crypto.git", from: "3.3.1"),
        .package(url: "https://github.com/vapor/vapor.git", from: "3.1.1"),
        .package(url: "https://github.com/thepeaklab/mockturtle-parser.git", from: "0.2.0")
    ],
    targets: [
        .target(name: "App", dependencies: ["MockturtleParser", "Crypto", "Random", "Vapor"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)


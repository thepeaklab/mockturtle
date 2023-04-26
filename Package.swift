// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "Mockturtle",
    platforms: [
        .macOS(.v10_15)
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-crypto", from: "2.0.5"),
        .package(url: "https://github.com/vapor/vapor.git", from: "4.76.0"),
        .package(url: "https://github.com/thepeaklab/mockturtle-parser.git", from: "0.2.0")
    ],
    targets: [
        .target(name: "App", dependencies: [
            .product(name: "MockturtleParser", package: "mockturtle-parser"),
            .product(name: "Vapor", package: "vapor"),
            .product(name: "Crypto", package: "swift-crypto")
        ]),
        .executableTarget(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)


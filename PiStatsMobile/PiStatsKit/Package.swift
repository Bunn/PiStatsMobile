// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PiStatsKit",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "PiStatsKit",
            type: .dynamic,
            targets: ["PiStatsKit"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Bunn/SwiftHole", from: "3.0.0"),
        .package(url: "https://github.com/Bunn/PiMonitor", from: "0.0.6"),
    ],
    targets: [
        .target(name: "PiStatsKit", dependencies: [
            .product(name: "SwiftHole", package: "SwiftHole"),
            .product(name: "PiMonitor", package: "PiMonitor"),
        ]),
    ]
)

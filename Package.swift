// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Connector",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(name: "connector", targets: ["connector"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "connector", dependencies: [], path: "Sources"),
    ],
    swiftLanguageVersions: [.v5]
)

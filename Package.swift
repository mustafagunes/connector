// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Connector",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(name: "Connector", targets: ["Connector"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "Connector", dependencies: [], path: "Sources"),
    ],
    swiftLanguageVersions: [.v5]
)

// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkLayer",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        .library(
            name: "NetworkLayer",
            targets: ["NetworkLayer"]
        ),
    ],
    targets: [
        .target(
            name: "NetworkLayer"),
        .testTarget(
            name: "NetworkLayerTests",
            dependencies: ["NetworkLayer"]
        ),
    ]
)

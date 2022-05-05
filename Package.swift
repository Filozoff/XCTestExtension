// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XCTestExtension",
    products: [
        .library(
            name: "XCTestExtension",
            targets: ["XCTestExtension"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "XCTestExtension",
            dependencies: []
        ),
        .testTarget(
            name: "XCTestExtensionTests",
            dependencies: ["XCTestExtension"]
        )
    ]
)

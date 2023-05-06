// swift-tools-version:5.8

import PackageDescription

let package = Package(
    name: "XCTestExtension",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .watchOS(.v6),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "XCTestExtension",
            targets: [
                "XCTestExtension"
            ]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
        .package(url: "https://github.com/krzysztofzablocki/Difference", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "XCTestExtension",
            dependencies: [
                "Difference"
            ]
        ),
        .testTarget(
            name: "XCTestExtensionTests",
            dependencies: [
                "XCTestExtension"
            ]
        )
    ]
)

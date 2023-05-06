// swift-tools-version:5.8

import PackageDescription

let package = Package(
    name: "XCTestExtension",
    platforms: [
        .iOS(.v11),
        .macOS(.v10_13),
        .watchOS(.v4),
        .tvOS(.v11)
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

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
        .package(url: "https://github.com/apple/swift-docc-plugin", exact: "1.2.0"),
        .package(url: "https://github.com/krzysztofzablocki/Difference", exact: "1.0.2")
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

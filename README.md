# XCTestExtension

[![CI](https://github.com/Filozoff/XCTestExtension/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/Filozoff/XCTestExtension/actions/workflows/ci.yml)
[![Codecov](https://codecov.io/gh/Filozoff/XCTestExtension/branch/master/graph/badge.svg)](https://codecov.io/gh/Filozoff/XCTestExtension)
![Swift](https://img.shields.io/badge/Swift-5.8-orange)
![Platforms](https://img.shields.io/badge/Platforms-iOS%20%7C%20macOS%20%7C%20watchOS%20%7C%20tvOS-red)
![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-green)
![GitHub](https://img.shields.io/github/license/Filozoff/XCTestExtension)

The framework provides additional assertion methods like:
- throwing `Error` type check
- throwing specific `Error` check when it conforms to `Equatable`
- values difference

and helpers for `Combine`'s `Publisher`s testing.

## Documentation

Documentation is generated by DocC. [Full documentation can be found here](https://filozoff.github.io/XCTestExtension/).

## Requirements

| Item | Minimum tool version |
| --- | --- |
| Swift | 5.8 |
| Xcode | 14.3 |

| Item | Minimum target version |
| --- | --- |
| iOS | 13.0 |
| macOS | 10.15 |
| watchOS | 6.0 |
| tvOS | 13.0 |

## Installation

### Swift Package Manager

[The Swift Package Manager](https://www.swift.org/package-manager/) is a tool for automating the distribution of [Swift](https://www.swift.org) code and is integrated into the swift compiler.

Once you have your Swift package set up, add XCTestExtension as a dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/Filozoff/XCTestExtension.git", branch: "master")
]
```
and add it to you `testTarget`'s dependencies:
```swift
targets: [
    (...)
    .testTarget(
        (...)
        dependencies: [
            (...)
            "XCTestExtension"
        ]
    )
]
```

### Xcode project (Swift Package Manager)

1. Go to **File->Add Packages...**
2. Paste `https://github.com/Filozoff/XCTestExtension.git` in **"Search or Enter Package URL"**
3. Choose **Dependency Rule** and **Project** suited to you needs and go to **Add Package**
4. Choose your test target under **Add to Target** and go to **Add Package**

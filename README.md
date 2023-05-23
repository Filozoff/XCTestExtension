![XCTestExtension: XCTest assertions and helpers](Images/XCTestExtensionLogo-dark.png#gh-dark-mode-only)
![XCTestExtension: XCTest assertions and helpers](Images/XCTestExtensionLogo-light.png#gh-light-mode-only)

# XCTestExtension

[![CI](https://github.com/Filozoff/XCTestExtension/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/Filozoff/XCTestExtension/actions/workflows/ci.yml)
[![Codecov](https://codecov.io/gh/Filozoff/XCTestExtension/branch/master/graph/badge.svg)](https://codecov.io/gh/Filozoff/XCTestExtension)
[![Swift Supported Versions](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FFilozoff%2FXCTestExtension%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/Filozoff/XCTestExtension)
[![Platforms](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FFilozoff%2FXCTestExtension%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/Filozoff/XCTestExtension)
![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-green)
![GitHub](https://img.shields.io/github/license/Filozoff/XCTestExtension)

The framework provides additional assertion methods like:
- throwing `Error` type check
- throwing specific `Error` check when it conforms to `Equatable`
- timeouting `async` operations
- values difference

and helpers for `Combine`'s `Publisher`s testing.

## Example usage

### Work with structured concurrency

It may happen that `async` operations don't return a value or don't throw any error (e.g. when converting from closures or `Combine`). In that case, they will hang out for infinity. The [XCTTimeout](https://filozoff.github.io/XCTestExtension/documentation/xctestextension/xctest/xctestcase/xcttimeout(_:timeout:_:file:line:)) catches that issue and throws an error, unblocking the hanging async task.

```swift
func test_whenGetDetails_thenReceivedExpectedDetails() {

    (...)

    // when
    let details = try await XCTTimeout(
        await sut.getDetails(),
        timeout: 0.01
    )

    // then
    XCTAssertEqual(details, expectedDetails)
}
```

### Work with `Combine`'s `Publisher` and expectation

Use [`PublisherExpectation`](https://filozoff.github.io/XCTestExtension/documentation/xctestextension/publisherexpectation) to simplify work with `Publisher`'s streams and avoid boilerplate code.

As an example, for a stream value observation, use `receivedValue(predicate:)`. To expect a specific value received from the stream, set the `predicate` parameter to:

```swift
predicate: { $0 == expectedValue }
```

A complete code example is below:

```swift
func test_givenValue_whenPublisherSend_thenReceivedExpectedValueInStream() {

    // given
    let value = "charizard"
    let expectedValue = value
    let sut = PassthroughSubject<String, Error>()
    let expectation = PublisherExpectation(
        sut,
        observation: .receivedValue(
            predicate: { $0 == expectedValue }
        ),
        description : "Publisher did not receive expected value \(expectedValue)"
    )

    // when
    sut.send(value)

    // then
    wait(for: [expectation], timeout: 0.01)
}
```

Use `.anyReceived()` convenience method where the value received from the stream does not matter.

For stream termination expectation, use `.completion(predicate:)` or `.anyCompletion()`.

### Additional assertions

`XCTAssertEqual` does not provide a readable output for not equal values. Use `XCTAssertNoDiff` to receive a readable diff.

`XCTAssertNoDiff` relies on [Difference](https://github.com/krzysztofzablocki/Difference) created by [Krzysztof Zabłocki](https://github.com/krzysztofzablocki).

## Documentation

Documentation is generated by DocC.

[Getting started can be found here](https://filozoff.github.io/XCTestExtension/documentation/xctestextension/gettingstarted).

[Full documentation can be found here](https://filozoff.github.io/XCTestExtension/).

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

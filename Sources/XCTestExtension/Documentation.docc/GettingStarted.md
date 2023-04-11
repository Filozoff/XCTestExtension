# Getting Started with XCTExtension

Make your work with `XCTests` easier.

## Work with expecations

Use ``PublisherExpectation`` to simplify work with `Publisher`'s streams and avoid boilerplate code. 

As an example, for a stream value observation, use ``PublisherExpectation/Observation/receivedValue(predicate:)``. To expect a specific value received from the stream, set the `predicate` parameter to:

```swift
predicate: { $0 == expectedValue }
```

A complete code example below:

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

Use ``PublisherExpectation/Observation/anyReceived()`` convenience method in case where value received from the stream does not matter.

For stream termination expectation, use ``PublisherExpectation/Observation/completion(predicate:)`` or ``PublisherExpectation/Observation/anyCompletion()``.

## Work with structured concurrency

It may happen that `async` operations don't return a value or throw any error (e.g. when converting from closures or `Combine`). In that case, they will hang out for infinity. Besides a production code, it especially matters on CI, where the used resources are important and the output feedback is not as instant as running tests locally. The `XCTimeout` assertion resolves that issue.

An example of its usage may be found below:

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

Additionally, `XCTimeout` allows to return a result from a method provided in `expression` parameter. The return value must inherit from `Sendable`.

## Compare objects

`XCTAssertEqual` does not provide a readable output for not equal values. Use ``XCTAssertNoDiff(_:_:_:file:line:)`` to receive a readable diff. 

``XCTAssertNoDiff(_:_:_:file:line:)`` relies on [Difference](https://github.com/krzysztofzablocki/Difference).

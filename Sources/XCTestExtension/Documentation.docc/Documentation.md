# ``XCTestExtension``

A list of additional assertion methods for `XCTest` framework and `async` counterparts for some of them.

## Overview

The framework provides additional assertion methods to make tests easier, more reliable and precise.
It has assertions for `Error` type and equality, values difference and some async counterparts for `XCAssert` methods provided by the Apple.
As an addition, it has an expectation object which helps working with `Combine`'s `Publisher`.

## Topics

### Tutorials

- <doc:GettingStarted>

### Regular assertions

- ``XCTAssertNoDiff(_:_:_:file:line:)``
- ``XCTAssertThrowsErrorEqual(_:_:_:file:line:)-4vuku``
- ``XCTAssertThrowsErrorType(_:_:_:file:line:)-2mglq``

### XCTest async counterparts

- ``XCTAssertNoThrow(_:_:file:line:)``
- ``XCTAssertThrowsError(_:_:file:line:_:)``
- ``XCTAssertThrowsErrorEqual(_:_:_:file:line:)-7l869``
- ``XCTAssertThrowsErrorType(_:_:_:file:line:)-6he7n``

### Expectations

- ``PublisherExpectation``

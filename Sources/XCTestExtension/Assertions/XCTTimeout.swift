import XCTest

extension XCTestCase {

    /// Asserts that an expression returns it's result  before reaching given timeout.
    ///
    /// - Parameters:
    ///   - expression: An expression of an `async` method.
    ///   - timeout: A timeout for given `expression`.
    ///   - message: An optional description of the failure.
    ///   - file: The file in which failure occurred. Defaults to the file name of the test case in which this function was called.
    ///   - line: The line number on which failure occurred. Defaults to the line number on which this function was called.
    /// - Returns: A value of type `T`, the result of evaluating the given `expression`.
    /// - Throws: An error when `expression` does not return result before reaching the given timeout. It will also rethrow any error thrown while evaluating the given expression.
    public func XCTTimeout<T>(
        _ expression: @autoclosure @escaping @Sendable () async throws -> T,
        timeout: TimeInterval,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #filePath,
        line: UInt = #line
    ) async throws -> T where T: Sendable {
        let expectation = XCTestExpectation(description: "Operation should be finished before timeout")
        let task = Task(priority: .userInitiated) {
            try await waitForTask(withTimeout: timeout) {
                defer { expectation.fulfill() }
                return try await expression()
            }
        }

        let result = await XCTWaiter.fulfillment(of: [expectation], timeout: timeout)

        switch result {
        case .timedOut:
            continueAfterFailure = false
            record(
                .init(
                    type: .assertionFailure,
                    compactDescription: "XCTTimeout failed: Operation has exceeded \(timeout)s".addMessage(message()),
                    sourceCodeContext: .init(
                        location: .init(filePath: file, lineNumber: line)
                    )
                )
            )

        default: break
        }

        return try await task.value
    }
}

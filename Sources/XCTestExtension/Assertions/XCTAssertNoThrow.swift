import XCTest

/// Asserts that an async expression doesn’t throw an error.
/// 
/// - Parameters:
///   - expression: An async expression that can throw an error.
///   - message: An optional description of a failure.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public func XCTAssertNoThrow<T>(
    _ expression: @autoclosure () async throws -> T,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #filePath,
    line: UInt = #line
) async where T: Sendable {
    let result = await Result { try await expression() }
    assert(try result.get(), message(), file: file, line: line)
}

private func assert<T>(
    _ expression: @autoclosure () throws -> T,
    _ message: @autoclosure () -> String,
    file: StaticString,
    line: UInt
) {
    XCTAssertNoThrow(try expression(), message(), file: file, line: line)
}

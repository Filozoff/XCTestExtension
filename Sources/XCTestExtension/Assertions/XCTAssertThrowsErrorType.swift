import Foundation
import XCTest

/// Asserts that an expression throws an error of a given type.
///
/// Use this function to check if an expression throws an error of a given type.
///
/// - Parameters:
///   - expression1: An expression that can throw an error.
///   - expression2: A second expression of error type.
///   - message: An optional description of the assertion, for inclusion in test results.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
public func XCTAssertThrowsErrorType<T, E>(
    _ expression1: @autoclosure () throws -> T,
    _ expression2: E.Type,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #filePath,
    line: UInt = #line
) where E: Error {
    assert(try expression1(), expression2, message(), file: file, line: line)
}

/// Asserts that an async expression throws an error of a given type.
///
/// Use this function to check if an async expression throws an error of a given type.
///
/// - Parameters:
///   - expression1: An async expression that can throw an error.
///   - expression2: A second expression of error type.
///   - message: An optional description of the assertion, for inclusion in test results.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public func XCTAssertThrowsErrorType<T, E>(
    _ expression1: @autoclosure () async throws -> T,
    _ expression2: E.Type,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #filePath,
    line: UInt = #line
) async where E: Error, T: Sendable {
    let result = await Result { try await expression1() }
    assert(try result.get(), expression2, message(), file: file, line: line)
}

private func assert<T, E>(
    _ expression1: @autoclosure () throws -> T,
    _ expression2: E.Type,
    _ message: @autoclosure () -> String,
    file: StaticString,
    line: UInt
) where E: Error {
    do {
        _ = try expression1()
        XCTFail("Did not throw an error".addMessage(message()), file: file, line: line)
    } catch let error {
        if error is E { return }
        XCTFail(
            #"Error type mismatch. Expected ("\#(E.self)") but received ("\#(type(of: error))")"#.addMessage(message()),
            file: file,
            line: line
        )
    }
}

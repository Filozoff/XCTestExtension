import Foundation
import XCTest

/// Asserts that an expression throws a specified error.
///
/// Use this function to check if an expression throws a specified error. The error must conform to `Equatable`.
///
/// - Parameters:
///   - expression1: An expression that can throw an error.
///   - expression2: A second expression returning specified error.
///   - message: An optional description of the assertion, for inclusion in test results.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
public func XCTAssertThrowsErrorEqual<T, E>(
    _ expression1: @autoclosure () throws -> T,
    _ expression2: @autoclosure () -> E,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #filePath,
    line: UInt = #line
) where E: Error & Equatable {
    do {
        _ = try expression1()
        XCTFail("Did not throw an error".addMessage(message()), file: file, line: line)
    } catch let error {
        guard let thrownError = error as? E else {
            XCTFail(
                #"Error type mismatch. Expected ("\#(E.self)") but received ("\#(type(of: error))")"#.addMessage(message()),
                file: file,
                line: line
            )
            return
        }

        XCTAssertEqual(thrownError, expression2(), message(), file: file, line: line)
    }
}

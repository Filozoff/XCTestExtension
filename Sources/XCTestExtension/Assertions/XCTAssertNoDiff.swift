import Difference
import XCTest

/// Asserts that two values have no difference.
///
/// Use this function to compare two non-optional values of the same type.
/// Assertion uses [`Difference`](https://github.com/krzysztofzablocki/Difference) library.
/// The differences are presented in readable form.
///
/// - Parameters:
///   - expression1: An expression of type `T`, where `T` is `Equatable`.
///   - expression2: A second expression of type T, where T is `Equatable`.
///   - message: An optional description of the failure.
///   - file: The file in which failure occurred. Defaults to the file name of the test case in which this function was called.
///   - line: The line number on which failure occurred. Defaults to the line number on which this function was called.
public func XCTAssertNoDiff<T: Equatable>(
    _ expression1: @autoclosure () throws -> T,
    _ expression2: @autoclosure () throws -> T,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #filePath,
    line: UInt = #line
) {
    do {
        let received = try expression1()
        let expected = try expression2()
        let message = "Found difference: \n" + diff(expected, received)
            .joined(separator: ", ")
            .addMessage(message())

        XCTAssertTrue(expected == received, message, file: file, line: line)
    } catch {
        XCTFail("Caught error while testing: \(error)", file: file, line: line)
    }

    XCTAssertEqual("", "")
}

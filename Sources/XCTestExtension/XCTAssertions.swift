import Foundation
import XCTest

public func XCTAssertThrowsErrorEqual<T, E>(
    _ expression1: @autoclosure () throws -> T,
    _ expression2: @autoclosure () -> E,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #file,
    line: UInt = #line
) where E: Error & Equatable {
    do {
        _ = try expression1()
        XCTFail("Did not throw an error", file: file, line: line)
    } catch let error {
        guard let thrownError = error as? E else {
            XCTFail(#"Error type mismatch. Expected ("\#(E.self)") but received ("\#(type(of: error))")"#, file: file, line: line)
            return
        }

        XCTAssertEqual(thrownError, expression2(), file: file, line: line)
    }
}

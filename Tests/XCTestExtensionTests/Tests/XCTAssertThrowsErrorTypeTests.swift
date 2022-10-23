import XCTest
@testable import XCTestExtension

final class XCTAssertThrowsErrorTypeTests: XCTestCase {

    func test_givenFailebleMethodWithMatchedError_whenAssertThrowsErrorType_thenMatch() throws {
        XCTAssertThrowsErrorType(try MethodStub.failable(with: SimpleEnumError.errorTwo), SimpleEnumError.self)
    }

    func test_givenFailableMethodWithDifferentErrorType_whenAssertThrowsErrorType_thenTestFailure() throws {
        XCTExpectFailure("Should fail because of error type mismatch")
        XCTAssertThrowsErrorType(try MethodStub.failable(with: EquatableError.errorTwo), SimpleEnumError.self)
    }

    func test_givenNonFailableMethod_whenAssertThrowsErrorType_thenTestFailure() throws {
        XCTExpectFailure("Should fail because of not throwing method")
        XCTAssertThrowsErrorType(try MethodStub.nonFailable(), SimpleEnumError.self)
    }
}

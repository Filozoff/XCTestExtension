import XCTest
@testable import XCTestExtension

final class XCTestExtensionTests: XCTestCase {
    
    func test_givenFailableMethodWithMatchedError_whenAssertThrowsErrorEqual_thenMatch() throws {
        XCTAssertThrowsErrorEqual(try MethodStub.failable(with: EquatableError.errorTwo), EquatableError.errorTwo)
    }

    func test_givenFailableMethodWithDifferentError_whenAssertThrowsErrorEqual_thenTestFailure() throws {
        XCTExpectFailure("Should fail because of not equal error")
        XCTAssertThrowsErrorEqual(try MethodStub.failable(with: EquatableError.errorOne), EquatableError.errorTwo)
    }

    func test_givenFailableMethodWithDifferentErrorType_whenAssertThrowsErrorEqual_thenTestFailure() throws {
        XCTExpectFailure("Should fail because of error type mismatch")
        XCTAssertThrowsErrorEqual(try MethodStub.failable(with: SimpleEnumError.errorTwo), EquatableError.errorTwo)
    }

    func test_givenNonFailableMethod_whenAssertThrowsErrorEqual_thenTestFailure() throws {
        XCTExpectFailure("Should fail because of not throwing method")
        XCTAssertThrowsErrorEqual(try MethodStub.nonFailable(), EquatableError.errorTwo)
    }

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

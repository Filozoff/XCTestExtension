import XCTest
@testable import XCTestExtension

final class XCTAssertThrowsErrorTypeTests: XCTestCase {

    func test_givenFailebleMethodWithMatchedError_whenAssertThrowsErrorType_thenMatch() throws {
        XCTAssertThrowsErrorType(try MethodStub.failable(with: SimpleEnumError.errorTwo), SimpleEnumError.self)
    }

    func test_givenFailableMethodWithDifferentErrorType_whenAssertThrowsErrorType_thenTestFailure() throws {
        XCTExpectFailure("Should fail due to error type mismatch")
        XCTAssertThrowsErrorType(try MethodStub.failable(with: EquatableError.errorTwo), SimpleEnumError.self)
    }

    func test_givenNonFailableMethod_whenAssertThrowsErrorType_thenTestFailure() throws {
        XCTExpectFailure("Should fail due to not throwing method")
        XCTAssertThrowsErrorType(try MethodStub.nonFailable(), SimpleEnumError.self)
    }

    // MARK: - Async

    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    func test_givenFailebleMethodWithMatchedError_whenAsyncAssertThrowsErrorType_thenMatch() async throws {
        await XCTAssertThrowsErrorType(try MethodStub.failable(with: SimpleEnumError.errorTwo), SimpleEnumError.self)
    }

    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    func test_givenFailableMethodWithDifferentErrorType_whenAsyncAssertThrowsErrorType_thenTestFailure() async throws {
        XCTExpectFailure("Should fail due to error type mismatch")
        await XCTAssertThrowsErrorType(try MethodStub.failable(with: EquatableError.errorTwo), SimpleEnumError.self)
    }

    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    func test_givenNonFailableMethod_whenAsyncAssertThrowsErrorType_thenTestFailure() async throws {
        XCTExpectFailure("Should fail due to not throwing method")
        await XCTAssertThrowsErrorType(try MethodStub.nonFailable(), SimpleEnumError.self)
    }
}

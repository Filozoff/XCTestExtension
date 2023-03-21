import XCTest
@testable import XCTestExtension

final class XCTAssertThrowsErrorEqualTests: XCTestCase {

    func test_givenFailableMethodWithMatchedError_whenAssertThrowsErrorEqual_thenMatch() throws {
        XCTAssertThrowsErrorEqual(try MethodStub.failable(with: EquatableError.errorTwo), EquatableError.errorTwo)
    }

    func test_givenFailableMethodWithDifferentError_whenAssertThrowsErrorEqual_thenTestFailure() throws {
        XCTExpectFailure("Should fail due to not equal error")
        XCTAssertThrowsErrorEqual(try MethodStub.failable(with: EquatableError.errorOne), EquatableError.errorTwo)
    }

    func test_givenFailableMethodWithDifferentErrorType_whenAssertThrowsErrorEqual_thenTestFailure() throws {
        XCTExpectFailure("Should fail due to error type mismatch")
        XCTAssertThrowsErrorEqual(try MethodStub.failable(with: SimpleEnumError.errorTwo), EquatableError.errorTwo)
    }

    func test_givenNonFailableMethod_whenAssertThrowsErrorEqual_thenTestFailure() throws {
        XCTExpectFailure("Should fail due to not throwing method")
        XCTAssertThrowsErrorEqual(try MethodStub.nonFailable(), EquatableError.errorTwo)
    }

    // MARK: - Async

    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    func test_givenFailableMethodWithMatchedError_whenAsyncAssertThrowsErrorEqual_thenMatch() async throws {
        await XCTAssertThrowsErrorEqual(try MethodStub.failable(with: EquatableError.errorTwo), EquatableError.errorTwo)
    }

    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    func test_givenFailableMethodWithDifferentError_whenAsyncAssertThrowsErrorEqual_thenTestFailure() async throws {
        XCTExpectFailure("Should fail due to not equal error")
        await XCTAssertThrowsErrorEqual(try MethodStub.failable(with: EquatableError.errorOne), EquatableError.errorTwo)
    }

    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    func test_givenFailableMethodWithDifferentErrorType_whenAsyncAssertThrowsErrorEqual_thenTestFailure() async throws {
        XCTExpectFailure("Should fail due to error type mismatch")
        await XCTAssertThrowsErrorEqual(try MethodStub.failable(with: SimpleEnumError.errorTwo), EquatableError.errorTwo)
    }

    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    func test_givenNonFailableMethod_whenAsyncAssertThrowsErrorEqual_thenTestFailure() async throws {
        XCTExpectFailure("Should fail due to not throwing method")
        await XCTAssertThrowsErrorEqual(try MethodStub.nonFailable(), EquatableError.errorTwo)
    }
}

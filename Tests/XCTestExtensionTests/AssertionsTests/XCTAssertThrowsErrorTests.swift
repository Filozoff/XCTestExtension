import XCTest
@testable import XCTestExtension

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
final class XCTAssertThrowsErrorTests: XCTestCase {

    func test_givenNonFailableMethod_whenAssertThrowsError_thenTestFailure() async throws {
        XCTExpectFailure("Should fail due to not throwing method")
        await XCTAssertThrowsError(try MethodStub.nonFailable())
    }

    func test_givenFailableMethod_whenAssertThrowsError_thenTestFailure() async throws {
        await XCTAssertThrowsError(try MethodStub.failable(with: EquatableError.errorTwo))
    }

    func test_givenNonFailableMethod_whenAssertThrowsError_thenReceivesExpectedErrorOnErrorHandler() async throws {
        await XCTAssertThrowsError(try MethodStub.failable(with: EquatableError.errorTwo)) { error in
            XCTAssertEqual(error as? EquatableError, .errorTwo)
        }
    }
}

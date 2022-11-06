import XCTest
@testable import XCTestExtension

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
final class XCTAssertNoThrowTest: XCTestCase {

    func test_givenFailableMethod_whenAssertNoThrow_thenTestFailure() async throws {
        XCTExpectFailure("Should fail because of not throwing method")
        await XCTAssertNoThrow(try MethodStub.failable(with: EquatableError.errorTwo))
    }

    func test_givenNonFailableMethod_whenAssertNoThrow_thenTestFailure() async throws {
        await XCTAssertNoThrow(try MethodStub.nonFailable())
    }
}

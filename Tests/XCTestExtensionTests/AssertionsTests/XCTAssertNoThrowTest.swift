import XCTest
@testable import XCTestExtension

final class XCTAssertNoThrowTest: XCTestCase {

    func test_givenFailableMethod_whenAssertNoThrow_thenTestFailure() async throws {
        XCTExpectFailure("Should fail due to not throwing method")
        await XCTAssertNoThrow(try MethodStub.failable(with: EquatableError.errorTwo))
    }

    func test_givenNonFailableMethod_whenAssertNoThrow_thenTestFailure() async throws {
        await XCTAssertNoThrow(try MethodStub.nonFailable())
    }
}

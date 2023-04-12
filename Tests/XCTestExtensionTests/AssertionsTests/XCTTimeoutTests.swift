import XCTest
@testable import XCTestExtension

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
final class XCTTimeoutTests: XCTestCase {

    static let longDelay = 1.0
    static let shortDelay = 0.2

    func test_givenLongAsync_whenTimeout_thenThrowsTimedOutError() async throws {
        try skipForNewCompiler()

        XCTExpectFailure("Should fail due to operation timeout")
        try await XCTTimeout(await MethodStub.asynchronous(after: Self.longDelay), timeout: Self.shortDelay)
    }

    func test_givenLongAsyncReturningMethod_whenTimeout_thenThrowsTimedOutError() async throws {
        try skipForNewCompiler()

        let expectedValue = "test_1234"
        XCTExpectFailure("Should fail due to operation timeout")
        _ = try await XCTTimeout(
            await MethodStub.asynchronous(return: expectedValue, after: Self.longDelay),
            timeout: Self.shortDelay
        )
    }

    func test_givenLongAsyncThrowingMethod_whenTimeout_thenThrowsTimedOutError() async throws {
        try skipForNewCompiler()

        XCTExpectFailure("Should fail due to operation timeout")
        try await XCTTimeout(
            await MethodStub.asynchronousThrowing(error: SimpleEnumError.errorOne, after: Self.longDelay),
            timeout: Self.shortDelay
        )
    }

    func test_givenShortAsyncReturningMethod_whenTimeout_thenReturnsExpectedValue() async throws {
        // given
        let expectedValue = "test_1234"

        // when
        let result = try await XCTTimeout(
            await MethodStub.asynchronous(return: expectedValue, after: Self.shortDelay),
            timeout: Self.longDelay
        )

        // then
        XCTAssertEqual(result, expectedValue)
    }

    func test_givenShortAsyncThrowableMethod_whenTimeout_thenReturnsExpectedValue() async throws {
        // given
        let value = "test_1234"

        // when
        let result = try await XCTTimeout(
            try await MethodStub.asynchronousThrowable(return: value, after: Self.shortDelay),
            timeout: Self.longDelay
        )

        // then
        XCTAssertEqual(result, value)
    }

    func test_givenShortAsyncThrowingMethod_whenTimeout_thenThrowsError() async throws {
        // given
        let expectedError = EquatableError.errorOne

        // when
        // then
        do {
            try await XCTTimeout(
                await MethodStub.asynchronousThrowing(error: EquatableError.errorOne, after: Self.shortDelay),
                timeout: Self.longDelay
            )
        } catch let error as EquatableError {
            XCTAssertEqual(error, expectedError)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}

extension XCTTimeoutTests {

    /// Skip tests as `XCTExpectFailure` works randomly for structured concurrency due to `XCTWaiter.fulfillment`.
    private func skipForNewCompiler(file: StaticString = #filePath, line: UInt = #line) throws {
        try XCTSkipIf(
            isUsingNewCompiler(),
            "Test skipped because of structured concurrency issues from `XCTWaiter.fulfillment`",
            file: file,
            line: line
        )
    }

    private func isUsingNewCompiler() -> Bool {
        #if compiler(>=5.8)
        return true
        #else
        return false
        #endif
    }
}

import XCTest
@testable import XCTestExtension

final class XCTAssertNoDiffTests: XCTestCase {

    func test_givenSameValues_whenAssertNoDiffCalled_thenSuccess() throws {
        // given
        let value = "test_1234"

        // when
        // then
        XCTAssertNoDiff(value, value)
    }

    func test_givenDifferentValues_whenAssertNoDiffCalled_thenTestFailure() throws {
        // given
        let value1 = "test_1234"
        let value2 = "test_4321"

        // when
        // then
        XCTExpectFailure("Should fail because of difference fount between values")
        XCTAssertNoDiff(value1, value2)
    }

    func test_givenDifferentValueCollections_whenAssertNoDiffCalled_thenTestFailure() throws {
        // given
        let value1: [EquatableStub] = [
            .init(boolStub: true, intStub: 0, stringStub: "test"),
            .init(boolStub: true, intStub: 0, stringStub: "test_1"),
            .init(boolStub: true, intStub: 0, stringStub: "test_2"),
            .init(boolStub: true, intStub: 0, stringStub: "test_3")
        ]

        let value2: [EquatableStub] = [
            .init(boolStub: true, intStub: 0, stringStub: "test"),
            .init(boolStub: true, intStub: 0, stringStub: "test_1"),
            .init(boolStub: false, intStub: 0, stringStub: "test_2"),
            .init(boolStub: true, intStub: 0, stringStub: "test_3")
        ]

        // when
        // then
        XCTExpectFailure("Should fail because of difference fount between values")
        XCTAssertNoDiff(value1, value2)
    }
}

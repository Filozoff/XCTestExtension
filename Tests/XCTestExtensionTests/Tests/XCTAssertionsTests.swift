import XCTest
@testable import XCTestExtension

final class XCTestExtensionTests: XCTestCase {
    
    func test_givenFailableMethodWithMatchedError_whenAssertThrowsErrorEqual_thenMatch() throws {
        XCTAssertThrowsErrorEqual(try Stub().failEquatableTwo(), Stub.EquatableError.errorTwo)
    }

    func test_givenFailableMethodWithDifferentError_whenAssertThrowsErrorEqual_thenTestFailure() throws {
        XCTExpectFailure("Should fail because of not equal error")
        XCTAssertThrowsErrorEqual(try Stub().failEquatableTwo(), Stub.EquatableError.errorOne)
    }

    func test_givenFailableMethodWithDifferentErrorType_whenAssertThrowsErrorEqual_thenTestFailure() throws {
        XCTExpectFailure("Should fail because of error type mismatch")
        XCTAssertThrowsErrorEqual(try Stub().fail(), Stub.EquatableError.errorTwo)
    }

    func test_givenNonFailableMethod_whenAssertThrowsErrorEqual_thenTestFailure() throws {
        XCTExpectFailure("Should fail because of not throwing method")
        XCTAssertThrowsErrorEqual(try Stub().nonFailable(), Stub.EquatableError.errorTwo)
    }

    func test_givenFailebleMethodWithMatchedError_whenAssertThrowsErrorType_thenMatch() throws {
        XCTAssertThrowsErrorType(try Stub().fail(), Stub.NonEquatableError.self)
    }

    func test_givenFailableMethodWithDifferentErrorType_whenAssertThrowsErrorType_thenTestFailure() throws {
        XCTExpectFailure("Should fail because of error type mismatch")
        XCTAssertThrowsErrorType(try Stub().failEquatableTwo(), Stub.NonEquatableError.self)
    }

    func test_givenNonFailableMethod_whenAssertThrowsErrorType_thenTestFailure() throws {
        XCTExpectFailure("Should fail because of not throwing method")
        XCTAssertThrowsErrorType(try Stub().nonFailable(), Stub.NonEquatableError.self)
    }
}

extension XCTestExtensionTests {

    struct Stub {

        enum NonEquatableError: Swift.Error {
            case errorOne
            case errorTwo
            case errorThree
        }

        enum EquatableError: Equatable, Swift.Error {
            case errorOne
            case errorTwo
            case errorThree
        }

        func fail() throws {
            throw NonEquatableError.errorTwo
        }

        func failEquatableTwo() throws {
            throw EquatableError.errorTwo
        }

        func nonFailable() throws { }
    }
}

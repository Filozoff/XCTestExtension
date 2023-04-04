import Combine
import XCTest
@testable import XCTestExtension

@available(iOS 13.0, *)
final class PublisherExpectationTests: XCTestCase {

    // MARK: - Default predicate

    func test_givenPublisherAndDefaultPredicate_whenPublisherSend_thenExpectationFulfilled() {

        // given
        let publisher = PassthroughSubject<String, EquatableError>()
        let sut = PublisherExpectation(publisher, description : "")

        // when
        publisher.send("test")

        // then
        wait(for: [sut], timeout: 0.1)
    }

    // MARK: - `anyCompletion` predicate

    func test_givenPublisherAndAnyCompletionPredicate_whenPublisherFinished_thenExpectationFulfilled() {

        // given
        let publisher = PassthroughSubject<String, EquatableError>()
        let sut = PublisherExpectation(
            publisher,
            observation: .anyCompletion(),
            description : ""
        )

        // when
        publisher.send(completion: .finished)

        // then
        wait(for: [sut], timeout: 0.1)
    }

    func test_givenPublisherAndAnyCompletionPredicate_whenPublisherSend_thenExpectationNotFulfilled() {

        // given
        let publisher = PassthroughSubject<String, EquatableError>()
        let sut = PublisherExpectation(
            publisher,
            observation: .anyCompletion(),
            description : ""
        )

        // when
        publisher.send("test")

        // then
        XCTExpectFailure("Should fail due to not fulfilled expectation")
        wait(for: [sut], timeout: 0.1)
    }

    func test_givenPublisherAndAnyCompletionPredicate_whenPublisherNotCalled_thenExpectationNotFulfilled() {

        // given
        let publisher = PassthroughSubject<String, EquatableError>()
        let sut = PublisherExpectation(
            publisher,
            observation: .anyCompletion(),
            description : ""
        )

        // when
        // then
        XCTExpectFailure("Should fail due to not fulfilled expectation")
        wait(for: [sut], timeout: 0.1)
    }

    func test_givenPublisherAndAnyCompletionPredicate_whenPublisherFailed_thenExpectationFulfilled() {

        // given
        let publisher = PassthroughSubject<String, EquatableError>()
        let sut = PublisherExpectation(
            publisher,
            observation: .anyCompletion(),
            description : ""
        )

        // when
        publisher.send(completion: .failure(.errorOne))

        // then
        wait(for: [sut], timeout: 0.1)
    }

    // MARK: - `success` predicate

    func test_givenPublisherAndCompletionSuccessPredicate_whenPublisherFinished_thenExpectationFulfilled() {

        // given
        let publisher = PassthroughSubject<String, EquatableError>()
        let sut = PublisherExpectation(
            publisher,
            observation: .completion(
                predicate: { $0 == .finished }
            ),
            description : ""
        )

        // when
        publisher.send(completion: .finished)

        // then
        wait(for: [sut], timeout: 0.1)
    }

    func test_givenPublisherAndCompletionSuccessPredicate_whenPublisherFailed_thenExpectationNotFulfilled() {

        // given
        let publisher = PassthroughSubject<String, EquatableError>()
        let sut = PublisherExpectation(
            publisher,
            observation: .completion(
                predicate: { $0 == .finished }
            ),
            description : ""
        )

        // when
        publisher.send(completion: .failure(.errorTwo))

        // then
        XCTExpectFailure("Should fail due to not fulfilled expectation")
        wait(for: [sut], timeout: 0.1)
    }

    // MARK: - `failure` predicate

    func test_givenPublisherAndCompletionFailurePredicate_whenPublisherFailed_thenExpectationFulfilled() {

        // given
        let error = EquatableError.errorOne
        let publisher = PassthroughSubject<String, EquatableError>()
        let sut = PublisherExpectation(
            publisher,
            observation: .completion(
                predicate: { $0 == .failure(error) }
            ),
            description : ""
        )

        // when
        publisher.send(completion: .failure(error))

        // then
        wait(for: [sut], timeout: 0.1)
    }

    func test_givenPublisherAndCompletionFailurePredicate_whenPublisherFinished_thenExpectationNotFulfilled() {

        // given
        let publisher = PassthroughSubject<String, EquatableError>()
        let sut = PublisherExpectation(
            publisher,
            observation: .completion(
                predicate: { $0 == .failure(.errorOne) }
            ),
            description : ""
        )

        // when
        publisher.send(completion: .finished)

        // then
        XCTExpectFailure("Should fail due to not fulfilled expectation")
        wait(for: [sut], timeout: 0.1)
    }

    // MARK: - `anyReceived` predicate

    func test_givenPublisherAndAnyReceivedPredicate_whenPublisherSend_thenExpectationFulfilled() {

        // given
        let publisher = PassthroughSubject<String, EquatableError>()
        let sut = PublisherExpectation(
            publisher,
            observation: .anyReceived(),
            description : ""
        )

        // when
        publisher.send("test")

        // then
        wait(for: [sut], timeout: 0.1)
    }

    func test_givenPublisherAndAnyReceivedPredicate_whenPublisherStreamCompleted_thenExpectationNotFulfilled() {

        // given
        let publisher = PassthroughSubject<String, EquatableError>()
        let sut = PublisherExpectation(
            publisher,
            observation: .anyReceived(),
            description : ""
        )

        // when
        publisher.send(completion: .finished)

        // then
        XCTExpectFailure("Should fail due to not fulfilled expectation")
        wait(for: [sut], timeout: 0.1)
    }

    func test_givenPublisherAndAnyReceivedPredicate_whenPublisherNotCalled_thenExpectationNotFulfilled() {

        // given
        let publisher = PassthroughSubject<String, EquatableError>()
        let sut = PublisherExpectation(
            publisher,
            observation: .anyReceived(),
            description : ""
        )

        // when
        // then
        XCTExpectFailure("Should fail due to not fulfilled expectation")
        wait(for: [sut], timeout: 0.1)
    }

    // MARK: - `receivedValue` predicate

    func test_givenPublisherAndReceiveValueSuccessPredicate_whenPublisherSend_thenExpectationFulfilled() {

        // given
        let value = "charizard"
        let publisher = PassthroughSubject<String, EquatableError>()
        let sut = PublisherExpectation(
            publisher,
            observation: .receivedValue(
                predicate: { $0 == value }
            ),
            description : ""
        )

        // when
        publisher.send(value)

        // then
        wait(for: [sut], timeout: 0.1)
    }

    func test_givenPublisherAndReceiveValueFailurePredicate_whenPublisherSend_thenExpectationNotFulfilled() {

        // given
        let value = "pikachu"
        let sendValue = "\(value)_1"
        let publisher = PassthroughSubject<String, EquatableError>()
        let sut = PublisherExpectation(
            publisher,
            observation: .receivedValue(
                predicate: { $0 == value }
            ),
            description : ""
        )

        // when
        publisher.send(sendValue)

        // then
        XCTExpectFailure("Should fail due to not fulfilled expectation")
        wait(for: [sut], timeout: 0.1)
    }
}

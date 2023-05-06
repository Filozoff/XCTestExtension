import Combine
import XCTest

/// An expectation that is fulfilled when an `Option`'s `Predicate` for a `Publisher` is satisfied.
public class PublisherExpectation<Publisher>: XCTestExpectation where Publisher: Combine.Publisher {

    private(set) var cancellables = [AnyCancellable]()
    private let observation: Observation
    private let publisher: Publisher

    /// Creates an expectation for a provided `Publisher` that is fulfilled when an ``Observation``'s `Predicate` returns `true`.
    /// - Parameters:
    ///   - publisher: The publisher which stream is observed.
    ///   - observation: The observation which contains predicate. `.anyReceived()` by default.
    ///   - description: A string to display in the test log for this expectation, to help diagnose failures.
    public init(
        _ publisher: Publisher,
        observation: Observation = .anyReceived(),
        description: String
    ) {
        self.publisher = publisher
        self.observation = observation
        super.init(description: description)

        observePublisher()
    }

    private func observePublisher() {
        publisher.sink(
            receiveCompletion: { [weak self] in
                guard let self else { return }
                switch self.observation {
                case .completion(let predicate):
                    guard predicate($0) else { return }
                    self.fulfill()
                default: return
                }
            },
            receiveValue: { [weak self] in
                guard let self else { return }
                switch self.observation {
                case .receivedValue(let predicate):
                    guard predicate($0) else { return }
                    self.fulfill()
                default: return
                }
            }
        )
        .store(in: &cancellables)
    }
}

extension PublisherExpectation {

    /// A `Publisher` observation. Two observation are available: `completion` and `receivedValue`.
    public enum Observation {

        public typealias Predicate<T> = (T) -> Bool

        /// Observes on stream's completion.
        case completion(predicate: Predicate<Subscribers.Completion<Publisher.Failure>>)
        /// Observes on stream's received value.
        case receivedValue(predicate: Predicate<Publisher.Output>)

        /// A convenient method for `completion` observation which returns `true` for any stream's completion result.
        public static func anyCompletion() -> Self { .completion { _ in return true } }

        /// A convenient method for `receivedValue` observation which returns `true` for any value received from the stream.
        public static func anyReceived() -> Self { .receivedValue { _ in return true } }
    }
}

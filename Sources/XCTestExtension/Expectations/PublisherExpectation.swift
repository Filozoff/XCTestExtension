import Combine
import XCTest

@available(iOS 13.0, *)
public class PublisherExpectation<Publisher>: XCTestExpectation where Publisher: Combine.Publisher {

    private(set) var cancellables = [AnyCancellable]()
    private let option: Option
    private let publisher: Publisher

    public init(
        _ publisher: Publisher,
        option: Option = .anyReceived(),
        description: String
    ) {
        self.publisher = publisher
        self.option = option
        super.init(description: description)

        observePublisher()
    }

    private func observePublisher() {
        publisher.sink(
            receiveCompletion: { [weak self] in
                guard let self else { return }
                switch self.option {
                case .completion(let predicate):
                    guard predicate($0) else { return }
                    self.fulfill()
                default: return
                }
            },
            receiveValue: { [weak self] in
                guard let self else { return }
                switch self.option {
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

@available(iOS 13.0, *)
extension PublisherExpectation {

    public enum Option {

        public typealias Predicate<T> = (T) -> Bool

        case completion(predicate: Predicate<Subscribers.Completion<Publisher.Failure>>)
        case receivedValue(predicate: Predicate<Publisher.Output>)

        public static func anyCompletion() -> Self { .completion { _ in return true } }
        public static func anyReceived() -> Self { .receivedValue { _ in return true } }
    }
}

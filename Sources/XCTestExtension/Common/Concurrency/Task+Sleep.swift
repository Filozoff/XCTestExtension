import Foundation

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Task where Success == Never, Failure == Never {

    static func sleep(seconds: TimeInterval) async throws {
        try await Self.sleep(nanoseconds: .init(1_000_000_000 * seconds))
    }
}

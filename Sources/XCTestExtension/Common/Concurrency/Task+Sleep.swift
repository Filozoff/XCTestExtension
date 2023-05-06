import Foundation

extension Task where Success == Never, Failure == Never {

    static func sleep(seconds: TimeInterval) async throws {
        try await Self.sleep(nanoseconds: .init(1_000_000_000 * seconds))
    }
}

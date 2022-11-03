import Foundation

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
func waitForTask<R>(
    withTimeout timeout: TimeInterval,
    _ task: @escaping () async throws -> R
) async throws -> R {
    try await withThrowingTaskGroup(of: R.self) { group in
        await withUnsafeContinuation { continuation in
            group.addTask {
                continuation.resume()
                return try await task()
            }
        }

        group.addTask {
            await Task.yield()
            try await Task.sleep(seconds: timeout)
            throw TimedOutError()
        }

        defer { group.cancelAll() }
        return try await group.next()!
    }
}


struct TimedOutError: Equatable, Error { }

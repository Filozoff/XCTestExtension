import Foundation

func waitForTask<R>(
    withTimeout timeout: TimeInterval,
    _ task: @escaping @Sendable () async throws -> R
) async throws -> R where R: Sendable {
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

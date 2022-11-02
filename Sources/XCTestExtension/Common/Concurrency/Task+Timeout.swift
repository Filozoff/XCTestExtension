import Foundation

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public func waitForTask<R>(
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

        let result = try await group.next()!
        group.cancelAll()

        return result
    }
}


struct TimedOutError: Equatable, Error { }

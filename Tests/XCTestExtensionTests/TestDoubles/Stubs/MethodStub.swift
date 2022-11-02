import Foundation

struct MethodStub {

    static func failable<E>(with error: E) throws where E: Error {
        throw error
    }

    static func nonFailable() throws { }

    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    static func asynchronous(after timeInterval: TimeInterval) async {
        await asynchronous(return: (), after: timeInterval)
    }

    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    static func asynchronous<T>(return value: T, after timeInterval: TimeInterval) async -> T {
        try? await Task.sleep(seconds: timeInterval)
        return value
    }

    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    static func asynchronousThrowable<T>(return value: T, after timeInterval: TimeInterval) async throws -> T {
        try await Task.sleep(seconds: timeInterval)
        return value
    }

    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    static func asynchronousThrowing(error: Error, after timeInterval: TimeInterval) async throws {
        try await Task.sleep(seconds: timeInterval)
        throw error
    }
}

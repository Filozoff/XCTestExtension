import Foundation
@testable import XCTestExtension

struct MethodStub {

    static func failable<E>(with error: E) throws where E: Error {
        throw error
    }

    static func nonFailable() throws { }

    static func asynchronous(after timeInterval: TimeInterval) async {
        await asynchronous(return: (), after: timeInterval)
    }

    static func asynchronous<T>(return value: T, after timeInterval: TimeInterval) async -> T {
        try? await Task.sleep(seconds: timeInterval)
        return value
    }

    static func asynchronousThrowable<T>(return value: T, after timeInterval: TimeInterval) async throws -> T {
        try await Task.sleep(seconds: timeInterval)
        return value
    }

    static func asynchronousThrowing(error: Error, after timeInterval: TimeInterval) async throws {
        try await Task.sleep(seconds: timeInterval)
        throw error
    }
}

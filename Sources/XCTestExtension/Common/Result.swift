import Foundation

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Result where Failure == Error, Success: Sendable {

    init(catching body: () async throws -> Success) async {
        do {
            let result = try await body()
            self = .success(result)
        } catch {
            self = .failure(error)
        }
    }
}

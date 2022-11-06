import Foundation

extension Result where Failure == Error, Success: Sendable {

    public init(catching body: () async throws -> Success) async {
        do {
            let result = try await body()
            self = .success(result)
        } catch {
            self = .failure(error)
        }
    }
}

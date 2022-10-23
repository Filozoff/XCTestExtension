import Foundation

extension String {

    func addMessage(_ message: String) -> String {
        [self, message].filter { !$0.isEmpty }.joined(separator: " - ")
    }
}

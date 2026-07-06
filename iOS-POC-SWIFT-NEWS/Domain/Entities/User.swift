import Foundation

struct User: Identifiable, Equatable {
    let id: String
    let name: String
    let email: String

    var initials: String {
        let parts = name.split(separator: " ")
        let letters = parts.compactMap { $0.first }.prefix(2)
        return String(letters).uppercased()
    }
}

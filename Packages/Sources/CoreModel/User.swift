import Foundation

public struct User: Identifiable, Equatable {
    public let id: String
    public let name: String
    public let email: String

    public init(id: String, name: String, email: String) {
        self.id = id
        self.name = name
        self.email = email
    }

    public var initials: String {
        let parts = name.split(separator: " ")
        let letters = parts.compactMap { $0.first }.prefix(2)
        return String(letters).uppercased()
    }
}

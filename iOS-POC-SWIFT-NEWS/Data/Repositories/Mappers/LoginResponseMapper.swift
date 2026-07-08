import Foundation

extension LoginResponseDTO {
    func toDomain() -> User {
        User(id: id, name: name, email: email)
    }
}

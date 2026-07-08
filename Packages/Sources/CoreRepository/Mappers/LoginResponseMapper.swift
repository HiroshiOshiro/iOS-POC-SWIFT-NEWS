import Foundation
import CoreModel
import CoreNetwork

extension LoginResponseDTO {
    func toDomain() -> User {
        User(id: id, name: name, email: email)
    }
}

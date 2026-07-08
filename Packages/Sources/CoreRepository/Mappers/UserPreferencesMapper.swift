import Foundation
import CoreModel
import CoreDataStore

extension UserPreferences {
    func toDomain() -> User? {
        guard isLoggedIn else { return nil }
        return User(id: userID, name: userName, email: userEmail)
    }
}

import Foundation
import CoreModel

public protocol UserDataRepository {
    func observeCurrentUser() -> AsyncStream<User?>
    func saveCurrentUser(_ user: User)
    func clearCurrentUser()
}

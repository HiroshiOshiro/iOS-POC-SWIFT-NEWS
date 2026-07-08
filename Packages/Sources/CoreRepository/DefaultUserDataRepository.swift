import Foundation
import CoreModel
import CoreDataStore

public final class DefaultUserDataRepository: UserDataRepository {
    private let dataSource: UserPreferencesDataSource

    public init(dataSource: UserPreferencesDataSource) {
        self.dataSource = dataSource
    }

    public func observeCurrentUser() -> AsyncStream<User?> {
        AsyncStream { continuation in
            let task = Task {
                for await preferences in dataSource.observe() {
                    continuation.yield(preferences.toDomain())
                }
            }
            continuation.onTermination = { _ in task.cancel() }
        }
    }

    public func saveCurrentUser(_ user: User) {
        dataSource.save(UserPreferences(isLoggedIn: true, userID: user.id, userName: user.name, userEmail: user.email))
    }

    public func clearCurrentUser() {
        dataSource.clear()
    }
}

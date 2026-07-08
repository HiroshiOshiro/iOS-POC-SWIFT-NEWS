import Foundation

public protocol UserPreferencesDataSource {
    func observe() -> AsyncStream<UserPreferences>
    func save(_ preferences: UserPreferences)
    func clear()
}

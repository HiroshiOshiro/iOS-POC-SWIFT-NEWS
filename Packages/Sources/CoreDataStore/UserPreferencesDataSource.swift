import Foundation

public protocol UserPreferencesDataSource: Sendable {
    func observe() -> AsyncStream<UserPreferences>
    func save(_ preferences: UserPreferences)
    func clear()
}

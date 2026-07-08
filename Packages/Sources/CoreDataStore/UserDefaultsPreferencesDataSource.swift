import Foundation
import Combine

public final class UserDefaultsPreferencesDataSource: UserPreferencesDataSource {
    private enum Key {
        static let isLoggedIn = "isLoggedIn"
        static let userID = "loggedInUserID"
        static let userName = "loggedInUserName"
        static let userEmail = "loggedInUserEmail"
    }

    private let defaults: UserDefaults
    private let subject: CurrentValueSubject<UserPreferences, Never>

    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        subject = CurrentValueSubject(Self.read(from: defaults))
    }

    public func observe() -> AsyncStream<UserPreferences> {
        AsyncStream { continuation in
            let cancellable = subject.sink { continuation.yield($0) }
            continuation.onTermination = { _ in cancellable.cancel() }
        }
    }

    public func save(_ preferences: UserPreferences) {
        defaults.set(preferences.isLoggedIn, forKey: Key.isLoggedIn)
        defaults.set(preferences.userID, forKey: Key.userID)
        defaults.set(preferences.userName, forKey: Key.userName)
        defaults.set(preferences.userEmail, forKey: Key.userEmail)
        subject.send(preferences)
    }

    public func clear() {
        save(.empty)
    }

    private static func read(from defaults: UserDefaults) -> UserPreferences {
        UserPreferences(
            isLoggedIn: defaults.bool(forKey: Key.isLoggedIn),
            userID: defaults.string(forKey: Key.userID) ?? "",
            userName: defaults.string(forKey: Key.userName) ?? "",
            userEmail: defaults.string(forKey: Key.userEmail) ?? ""
        )
    }
}

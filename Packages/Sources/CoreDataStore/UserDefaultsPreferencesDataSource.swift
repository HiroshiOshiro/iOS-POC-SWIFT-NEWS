import Foundation

public final class UserDefaultsPreferencesDataSource: UserPreferencesDataSource, @unchecked Sendable {
    private enum Key {
        static let isLoggedIn = "isLoggedIn"
        static let userID = "loggedInUserID"
        static let userName = "loggedInUserName"
        static let userEmail = "loggedInUserEmail"
    }

    private let defaults: UserDefaults
    // 配信状態はロックで保護する。Combine は使わず AsyncStream で複数の監視者へ多重配信する。
    private let lock = NSLock()
    private var current: UserPreferences
    private var continuations: [UUID: AsyncStream<UserPreferences>.Continuation] = [:]

    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        current = Self.read(from: defaults)
    }

    public func observe() -> AsyncStream<UserPreferences> {
        AsyncStream { continuation in
            let id = UUID()
            lock.lock()
            continuations[id] = continuation
            let value = current
            lock.unlock()

            // 購読直後に現在値を配信する（旧 CurrentValueSubject と同じ挙動）。
            continuation.yield(value)

            continuation.onTermination = { [weak self] _ in
                guard let self else { return }
                lock.lock()
                continuations[id] = nil
                lock.unlock()
            }
        }
    }

    public func save(_ preferences: UserPreferences) {
        defaults.set(preferences.isLoggedIn, forKey: Key.isLoggedIn)
        defaults.set(preferences.userID, forKey: Key.userID)
        defaults.set(preferences.userName, forKey: Key.userName)
        defaults.set(preferences.userEmail, forKey: Key.userEmail)

        lock.lock()
        current = preferences
        let targets = Array(continuations.values)
        lock.unlock()

        for continuation in targets {
            continuation.yield(preferences)
        }
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

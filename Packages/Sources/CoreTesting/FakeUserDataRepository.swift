import Foundation
import CoreModel
import CoreRepository

// Combine は使わず、ロックで保護した継続への多重配信で実装するインメモリFake。
public final class FakeUserDataRepository: UserDataRepository, @unchecked Sendable {
    private let lock = NSLock()
    private var current: User?
    private var continuations: [UUID: AsyncStream<User?>.Continuation] = [:]

    public init(initialUser: User? = nil) {
        current = initialUser
    }

    public func observeCurrentUser() -> AsyncStream<User?> {
        AsyncStream { continuation in
            let id = UUID()
            lock.lock()
            continuations[id] = continuation
            let value = current
            lock.unlock()

            continuation.yield(value)

            continuation.onTermination = { [weak self] _ in
                guard let self else { return }
                lock.lock()
                continuations[id] = nil
                lock.unlock()
            }
        }
    }

    public func saveCurrentUser(_ user: User) {
        publish(user)
    }

    public func clearCurrentUser() {
        publish(nil)
    }

    private func publish(_ user: User?) {
        lock.lock()
        current = user
        let targets = Array(continuations.values)
        lock.unlock()

        for continuation in targets {
            continuation.yield(user)
        }
    }
}

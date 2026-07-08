import Foundation
import Combine
import CoreModel
import CoreRepository

public final class FakeUserDataRepository: UserDataRepository {
    private let subject: CurrentValueSubject<User?, Never>

    public init(initialUser: User? = nil) {
        subject = CurrentValueSubject(initialUser)
    }

    public func observeCurrentUser() -> AsyncStream<User?> {
        AsyncStream { continuation in
            let cancellable = subject.sink { continuation.yield($0) }
            continuation.onTermination = { _ in cancellable.cancel() }
        }
    }

    public func saveCurrentUser(_ user: User) {
        subject.send(user)
    }

    public func clearCurrentUser() {
        subject.send(nil)
    }
}

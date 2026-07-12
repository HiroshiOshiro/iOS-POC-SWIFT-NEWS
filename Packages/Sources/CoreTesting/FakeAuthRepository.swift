import Foundation
import CoreModel
import CoreRepository

// テストダブル。テストが構成してから単一タスクで使う前提のため @unchecked Sendable とする。
public final class FakeAuthRepository: AuthRepository, @unchecked Sendable {
    public var result: Result<User, Error> = .failure(AuthError.invalidCredentials)

    public init() {}

    public func login(email: String, password: String) async throws -> User {
        try result.get()
    }
}

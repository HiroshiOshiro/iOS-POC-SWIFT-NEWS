import Foundation
import CoreModel
import CoreRepository

public final class FakeAuthRepository: AuthRepository {
    public var result: Result<User, Error> = .failure(AuthError.invalidCredentials)

    public init() {}

    public func login(email: String, password: String) async throws -> User {
        try result.get()
    }
}

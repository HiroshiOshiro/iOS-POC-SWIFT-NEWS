import Foundation
import CoreModel

public enum AuthError: Error, LocalizedError, Equatable {
    case invalidCredentials

    public var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "メールアドレスまたはパスワードが正しくありません"
        }
    }
}

public protocol AuthRepository: Sendable {
    func login(email: String, password: String) async throws -> User
}

import Foundation

enum AuthError: Error, LocalizedError {
    case invalidCredentials

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "メールアドレスまたはパスワードが正しくありません"
        }
    }
}

protocol AuthRepository {
    func login(email: String, password: String) async throws -> User
}

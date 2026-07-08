import Foundation
import CoreModel
import CoreNetwork

public enum AuthError: Error, LocalizedError {
    case invalidCredentials

    public var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "メールアドレスまたはパスワードが正しくありません"
        }
    }
}

public protocol AuthRepository {
    func login(email: String, password: String) async throws -> User
}

public final class AuthRepositoryImpl: AuthRepository {
    private let dataSource: AuthNetworkDataSource

    public init(dataSource: AuthNetworkDataSource) {
        self.dataSource = dataSource
    }

    public func login(email: String, password: String) async throws -> User {
        do {
            let dto = try await dataSource.login(email: email, password: password)
            return dto.toDomain()
        } catch NetworkError.httpStatus(401) {
            throw AuthError.invalidCredentials
        }
    }
}

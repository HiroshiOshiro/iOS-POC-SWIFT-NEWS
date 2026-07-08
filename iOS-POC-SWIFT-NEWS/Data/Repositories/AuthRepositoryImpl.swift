import Foundation

final class AuthRepositoryImpl: AuthRepository {
    private let dataSource: AuthNetworkDataSource

    init(dataSource: AuthNetworkDataSource) {
        self.dataSource = dataSource
    }

    func login(email: String, password: String) async throws -> User {
        do {
            let dto = try await dataSource.login(email: email, password: password)
            return dto.toDomain()
        } catch NetworkError.httpStatus(401) {
            throw AuthError.invalidCredentials
        }
    }
}

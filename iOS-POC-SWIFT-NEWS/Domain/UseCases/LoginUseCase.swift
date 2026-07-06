import Foundation

protocol LoginUseCase {
    func execute(email: String, password: String) async throws -> User
}

struct LoginUseCaseImpl: LoginUseCase {
    let authRepository: AuthRepository

    func execute(email: String, password: String) async throws -> User {
        try await authRepository.login(email: email, password: password)
    }
}

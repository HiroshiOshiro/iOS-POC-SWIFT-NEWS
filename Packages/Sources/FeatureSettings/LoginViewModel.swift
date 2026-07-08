import Foundation
import CoreModel
import CoreRepository

@MainActor
public final class LoginViewModel: ObservableObject {
    @Published public var email: String = ""
    @Published public var password: String = ""
    @Published public private(set) var isLoading = false
    @Published public var errorMessage: String?

    private let authRepository: AuthRepository

    public init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    public func login() async -> User? {
        isLoading = true
        defer { isLoading = false }
        do {
            return try await authRepository.login(email: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
            return nil
        }
    }
}

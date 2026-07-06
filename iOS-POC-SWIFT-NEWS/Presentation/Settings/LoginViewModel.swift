import Foundation

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let loginUseCase: LoginUseCase

    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }

    func login() async -> User? {
        isLoading = true
        defer { isLoading = false }
        do {
            return try await loginUseCase.execute(email: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
            return nil
        }
    }
}

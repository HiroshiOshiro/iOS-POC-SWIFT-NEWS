import Foundation
import Factory
import CoreModel
import CoreRepository

@MainActor
public final class LoginViewModel: ObservableObject {
    @Published public var email: String = ""
    @Published public var password: String = ""
    @Published public private(set) var isLoading = false
    @Published public var errorMessage: String?

    @Injected(\.authRepository) private var authRepository: AuthRepository
    @Injected(\.userDataRepository) private var userDataRepository: UserDataRepository

    public init() {}

    public func login() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let user = try await authRepository.login(email: email, password: password)
            userDataRepository.saveCurrentUser(user)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

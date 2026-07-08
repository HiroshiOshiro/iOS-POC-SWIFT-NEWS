import SwiftUI
import CoreRepository

public struct SettingsRootView: View {
    private let authRepository: AuthRepository
    private let userDataRepository: UserDataRepository
    @StateObject private var viewModel: SettingsRootViewModel

    public init(authRepository: AuthRepository, userDataRepository: UserDataRepository) {
        self.authRepository = authRepository
        self.userDataRepository = userDataRepository
        _viewModel = StateObject(wrappedValue: SettingsRootViewModel(userDataRepository: userDataRepository))
    }

    public var body: some View {
        NavigationView {
            if let user = viewModel.currentUser {
                UserProfileView(name: user.name, email: user.email) {
                    viewModel.logout()
                }
            } else {
                LoginView(authRepository: authRepository, userDataRepository: userDataRepository)
            }
        }
        .navigationViewStyle(.stack)
    }
}

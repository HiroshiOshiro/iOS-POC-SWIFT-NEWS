import SwiftUI
import CoreRepository

// SettingsNavigation.screen(...) 経由でのみ生成する
struct SettingsRootView: View {
    private let authRepository: AuthRepository
    private let userDataRepository: UserDataRepository
    @StateObject private var viewModel: SettingsRootViewModel

    init(authRepository: AuthRepository, userDataRepository: UserDataRepository) {
        self.authRepository = authRepository
        self.userDataRepository = userDataRepository
        _viewModel = StateObject(wrappedValue: SettingsRootViewModel(userDataRepository: userDataRepository))
    }

    var body: some View {
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

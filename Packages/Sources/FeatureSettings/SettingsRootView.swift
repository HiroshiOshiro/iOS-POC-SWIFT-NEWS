import SwiftUI

// SettingsNavigation.screen() 経由でのみ生成する
struct SettingsRootView: View {
    @StateObject private var viewModel = SettingsRootViewModel()

    var body: some View {
        NavigationView {
            if let user = viewModel.currentUser {
                UserProfileView(name: user.name, email: user.email) {
                    viewModel.logout()
                }
            } else {
                LoginView()
            }
        }
        .navigationViewStyle(.stack)
    }
}

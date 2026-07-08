import SwiftUI
import CoreRepository

public struct SettingsRootView: View {
    private let authRepository: AuthRepository

    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("loggedInUserName") private var loggedInUserName: String = ""
    @AppStorage("loggedInUserEmail") private var loggedInUserEmail: String = ""

    public init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    public var body: some View {
        NavigationView {
            if isLoggedIn {
                UserProfileView(name: loggedInUserName, email: loggedInUserEmail) {
                    isLoggedIn = false
                    loggedInUserName = ""
                    loggedInUserEmail = ""
                }
            } else {
                LoginView(authRepository: authRepository) { user in
                    loggedInUserName = user.name
                    loggedInUserEmail = user.email
                    isLoggedIn = true
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

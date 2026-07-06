import SwiftUI

struct SettingsRootView: View {
    let container: AppDIContainer

    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("loggedInUserName") private var loggedInUserName: String = ""
    @AppStorage("loggedInUserEmail") private var loggedInUserEmail: String = ""

    var body: some View {
        NavigationView {
            if isLoggedIn {
                UserProfileView(name: loggedInUserName, email: loggedInUserEmail) {
                    isLoggedIn = false
                    loggedInUserName = ""
                    loggedInUserEmail = ""
                }
            } else {
                LoginView(container: container) { user in
                    loggedInUserName = user.name
                    loggedInUserEmail = user.email
                    isLoggedIn = true
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

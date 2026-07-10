import SwiftUI
import CoreRepository

public enum SettingsNavigation {
    @ViewBuilder
    public static func screen(authRepository: AuthRepository, userDataRepository: UserDataRepository) -> some View {
        SettingsRootView(authRepository: authRepository, userDataRepository: userDataRepository)
    }

    public static var tabItem: some View {
        Label("Setting", systemImage: "gearshape")
    }
}

import SwiftUI

public enum SettingsNavigation {
    @ViewBuilder
    public static func screen() -> some View {
        SettingsRootView()
    }

    public static var tabItem: some View {
        Label("Setting", systemImage: "gearshape")
    }
}

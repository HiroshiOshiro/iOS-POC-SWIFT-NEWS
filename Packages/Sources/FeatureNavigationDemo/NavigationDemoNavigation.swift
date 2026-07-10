import SwiftUI

public enum NavigationDemoNavigation {
    @ViewBuilder
    public static func screen() -> some View {
        NavigationDemoListView()
    }

    public static var tabItem: some View {
        Label("画面遷移", systemImage: "rectangle.stack")
    }
}

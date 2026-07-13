import SwiftUI

public enum FavoritesNavigation {
    @ViewBuilder
    public static func screen() -> some View {
        FavoritesListView()
    }

    public static var tabItem: some View {
        Label("お気に入り", systemImage: "star")
    }
}

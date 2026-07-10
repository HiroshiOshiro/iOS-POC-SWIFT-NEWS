import SwiftUI
import CoreRepository

public enum FavoritesNavigation {
    @ViewBuilder
    public static func screen(favoritesRepository: FavoritesRepository) -> some View {
        FavoritesListView(favoritesRepository: favoritesRepository)
    }

    public static var tabItem: some View {
        Label("お気に入り", systemImage: "star")
    }
}

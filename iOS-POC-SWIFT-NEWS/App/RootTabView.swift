import SwiftUI
import FeatureNews
import FeatureFavorites
import FeatureSettings

struct RootTabView: View {
    let container: AppDIContainer

    var body: some View {
        TabView {
            NewsNavigation.screen(
                newsRepository: container.newsRepository,
                favoritesRepository: container.favoritesRepository
            )
            .tabItem { NewsNavigation.tabItem }

            FavoritesNavigation.screen(favoritesRepository: container.favoritesRepository)
                .tabItem { FavoritesNavigation.tabItem }

            SettingsNavigation.screen(
                authRepository: container.authRepository,
                userDataRepository: container.userDataRepository
            )
            .tabItem { SettingsNavigation.tabItem }
        }
    }
}

import SwiftUI
import FeatureNews
import FeatureFavorites
import FeatureSettings

struct RootTabView: View {
    let container: AppDIContainer

    var body: some View {
        TabView {
            NewsListView(
                newsRepository: container.newsRepository,
                favoritesRepository: container.favoritesRepository
            )
            .tabItem {
                Label("News", systemImage: "newspaper")
            }

            FavoritesListView(favoritesRepository: container.favoritesRepository)
                .tabItem {
                    Label("お気に入り", systemImage: "star")
                }

            SettingsRootView(
                authRepository: container.authRepository,
                userDataRepository: container.userDataRepository
            )
                .tabItem {
                    Label("Setting", systemImage: "gearshape")
                }
        }
    }
}

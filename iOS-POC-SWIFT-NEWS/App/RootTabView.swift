import SwiftUI
import FeatureNews
import FeatureFavorites
import FeatureSettings
import FeatureNavigationDemo

struct RootTabView: View {
    var body: some View {
        TabView {
            NewsNavigation.screen()
                .tabItem { NewsNavigation.tabItem }

            FavoritesNavigation.screen()
                .tabItem { FavoritesNavigation.tabItem }

            SettingsNavigation.screen()
                .tabItem { SettingsNavigation.tabItem }

            NavigationDemoNavigation.screen()
                .tabItem { NavigationDemoNavigation.tabItem }
        }
    }
}

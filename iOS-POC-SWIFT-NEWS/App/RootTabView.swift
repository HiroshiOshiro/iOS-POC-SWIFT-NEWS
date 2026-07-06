import SwiftUI

struct RootTabView: View {
    let container: AppDIContainer

    var body: some View {
        TabView {
            NewsListView(container: container)
                .tabItem {
                    Label("News", systemImage: "newspaper")
                }

            FavoritesListView(container: container)
                .tabItem {
                    Label("お気に入り", systemImage: "star")
                }

            SettingsRootView(container: container)
                .tabItem {
                    Label("Setting", systemImage: "gearshape")
                }
        }
    }
}

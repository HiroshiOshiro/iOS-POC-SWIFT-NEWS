import SwiftUI
import CoreRepository

// NiAの `NavGraphBuilder.forYouScreen(...)` に相当。
// App層はNewsListViewの存在を知らず、このfactory経由でのみ画面を構成する。
public enum NewsNavigation {
    @ViewBuilder
    public static func screen(newsRepository: NewsRepository, favoritesRepository: FavoritesRepository) -> some View {
        NewsListView(newsRepository: newsRepository, favoritesRepository: favoritesRepository)
    }

    public static var tabItem: some View {
        Label("News", systemImage: "newspaper")
    }
}

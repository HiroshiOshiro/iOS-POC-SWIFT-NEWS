import SwiftUI

// NiAの `NavGraphBuilder.forYouScreen(...)` に相当。
// App層はNewsListViewの存在を知らず、このfactory経由でのみ画面を構成する。
// RepositoryはこのブランチではFactoryの@Injectedで解決するため引数は不要。
public enum NewsNavigation {
    @ViewBuilder
    public static func screen() -> some View {
        NewsListView()
    }

    public static var tabItem: some View {
        Label("News", systemImage: "newspaper")
    }
}

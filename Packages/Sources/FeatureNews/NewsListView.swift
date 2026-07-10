import SwiftUI
import CoreModel
import CoreRepository
import CoreUI

// NewsNavigation.screen(...) 経由でのみ生成する(NiAのForYouScreenが
// NavGraphBuilder越しにしか呼ばれないのと同様、モジュール外には公開しない)
struct NewsListView: View {
    private let favoritesRepository: FavoritesRepository
    @StateObject private var viewModel: NewsListViewModel

    init(newsRepository: NewsRepository, favoritesRepository: FavoritesRepository) {
        self.favoritesRepository = favoritesRepository
        _viewModel = StateObject(wrappedValue: NewsListViewModel(
            newsRepository: newsRepository,
            favoritesRepository: favoritesRepository
        ))
    }

    var body: some View {
        NavigationView {
            content
                .navigationTitle("News")
                .task {
                    await viewModel.load()
                }
                .alert("エラー", isPresented: Binding(
                    get: { viewModel.errorMessage != nil },
                    set: { if !$0 { viewModel.errorMessage = nil } }
                )) {
                    Button("OK") { viewModel.errorMessage = nil }
                } message: {
                    Text(viewModel.errorMessage ?? "")
                }
        }
        .navigationViewStyle(.stack)
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.uiState {
        case .loading:
            ProgressView()
        case .success(let articles):
            List(articles) { article in
                NavigationLink {
                    NewsDetailView(
                        article: article,
                        isFavorite: viewModel.isFavorite(article),
                        favoritesRepository: favoritesRepository
                    )
                } label: {
                    NewsRow(
                        article: article,
                        isFavorite: viewModel.isFavorite(article),
                        onToggleFavorite: {
                            Task { await viewModel.toggleFavorite(article) }
                        }
                    )
                }
            }
            .listStyle(.plain)
            .refreshable {
                await viewModel.load()
            }
        case .failure(let message):
            VStack(spacing: 12) {
                Text("読み込みに失敗しました")
                    .font(.headline)
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Button("再試行") {
                    Task { await viewModel.load() }
                }
            }
        }
    }
}

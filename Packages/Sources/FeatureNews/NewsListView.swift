import SwiftUI
import CoreModel
import CoreRepository
import CoreUI

public struct NewsListView: View {
    private let favoritesRepository: FavoritesRepository
    @StateObject private var viewModel: NewsListViewModel

    public init(newsRepository: NewsRepository, favoritesRepository: FavoritesRepository) {
        self.favoritesRepository = favoritesRepository
        _viewModel = StateObject(wrappedValue: NewsListViewModel(
            newsRepository: newsRepository,
            favoritesRepository: favoritesRepository
        ))
    }

    public var body: some View {
        NavigationView {
            List(viewModel.articles) { article in
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
            .navigationTitle("News")
            .overlay {
                if viewModel.isLoading && viewModel.articles.isEmpty {
                    ProgressView()
                }
            }
            .refreshable {
                await viewModel.load()
            }
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
}

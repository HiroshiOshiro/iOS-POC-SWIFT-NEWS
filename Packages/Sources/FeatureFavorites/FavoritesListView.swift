import SwiftUI
import CoreModel
import CoreRepository
import CoreUI

public struct FavoritesListView: View {
    private let favoritesRepository: FavoritesRepository
    @StateObject private var viewModel: FavoritesListViewModel

    public init(favoritesRepository: FavoritesRepository) {
        self.favoritesRepository = favoritesRepository
        _viewModel = StateObject(wrappedValue: FavoritesListViewModel(favoritesRepository: favoritesRepository))
    }

    public var body: some View {
        NavigationView {
            Group {
                if viewModel.favorites.isEmpty && !viewModel.isLoading {
                    Text("お気に入りはまだありません")
                        .foregroundColor(.secondary)
                } else {
                    List(viewModel.favorites) { article in
                        NavigationLink {
                            NewsDetailView(
                                article: article,
                                isFavorite: true,
                                favoritesRepository: favoritesRepository
                            )
                        } label: {
                            NewsRow(
                                article: article,
                                isFavorite: true,
                                onToggleFavorite: {
                                    Task { await viewModel.removeFavorite(article) }
                                }
                            )
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("お気に入り")
            .task {
                await viewModel.load()
            }
            .refreshable {
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

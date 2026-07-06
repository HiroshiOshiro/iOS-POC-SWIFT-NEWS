import SwiftUI

struct FavoritesListView: View {
    let container: AppDIContainer
    @StateObject private var viewModel: FavoritesListViewModel

    init(container: AppDIContainer) {
        self.container = container
        _viewModel = StateObject(wrappedValue: container.makeFavoritesListViewModel())
    }

    var body: some View {
        NavigationView {
            Group {
                if viewModel.favorites.isEmpty && !viewModel.isLoading {
                    Text("お気に入りはまだありません")
                        .foregroundColor(.secondary)
                } else {
                    List(viewModel.favorites) { article in
                        NavigationLink {
                            NewsDetailView(container: container, article: article, isFavorite: true)
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

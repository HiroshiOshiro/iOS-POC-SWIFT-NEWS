import SwiftUI
import CoreModel
import CoreUI

// FavoritesNavigation.screen() 経由でのみ生成する
struct FavoritesListView: View {
    @StateObject private var viewModel = FavoritesListViewModel()

    var body: some View {
        NavigationView {
            content
                .navigationTitle("お気に入り")
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
        case .empty:
            Text("お気に入りはまだありません")
                .foregroundColor(.secondary)
        case .success(let favorites):
            List(favorites) { article in
                NavigationLink {
                    NewsDetailView(article: article, isFavorite: true)
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
}

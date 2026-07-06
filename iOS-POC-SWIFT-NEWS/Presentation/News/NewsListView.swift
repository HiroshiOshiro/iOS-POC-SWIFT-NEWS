import SwiftUI

struct NewsListView: View {
    let container: AppDIContainer
    @StateObject private var viewModel: NewsListViewModel

    init(container: AppDIContainer) {
        self.container = container
        _viewModel = StateObject(wrappedValue: container.makeNewsListViewModel())
    }

    var body: some View {
        NavigationView {
            List(viewModel.articles) { article in
                NavigationLink {
                    NewsDetailView(
                        container: container,
                        article: article,
                        isFavorite: viewModel.isFavorite(article)
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

struct NewsRow: View {
    let article: NewsArticle
    let isFavorite: Bool
    let onToggleFavorite: () -> Void

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(article.title)
                    .font(.body)
                    .lineLimit(2)
                Text("\(article.author) ・ \(article.score) points ・ \(article.commentCount) comments")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Button(action: onToggleFavorite) {
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .foregroundColor(isFavorite ? .yellow : .gray)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
    }
}

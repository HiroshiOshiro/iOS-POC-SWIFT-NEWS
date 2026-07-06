import SwiftUI

struct NewsDetailView: View {
    @StateObject private var viewModel: NewsDetailViewModel

    init(container: AppDIContainer, article: NewsArticle, isFavorite: Bool) {
        _viewModel = StateObject(wrappedValue: container.makeNewsDetailViewModel(article: article, isFavorite: isFavorite))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(viewModel.article.title)
                    .font(.title2)
                    .bold()

                Text("投稿者: \(viewModel.article.author)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                HStack(spacing: 16) {
                    Label("\(viewModel.article.score)", systemImage: "arrow.up")
                    Label("\(viewModel.article.commentCount)", systemImage: "bubble.right")
                }
                .font(.subheadline)
                .foregroundColor(.secondary)

                if let url = viewModel.article.url {
                    Link("記事を開く", destination: url)
                        .font(.body)
                }

                Spacer(minLength: 24)
            }
            .padding()
        }
        .navigationTitle("詳細")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Task { await viewModel.toggleFavorite() }
                } label: {
                    Image(systemName: viewModel.isFavorite ? "star.fill" : "star")
                        .foregroundColor(viewModel.isFavorite ? .yellow : .gray)
                }
            }
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
}

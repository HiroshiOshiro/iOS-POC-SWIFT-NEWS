import SwiftUI
import CoreModel
import CoreDesignSystem

public struct NewsDetailView: View {
    @StateObject private var viewModel: NewsDetailViewModel

    public init(article: NewsArticle, isFavorite: Bool) {
        _viewModel = StateObject(wrappedValue: NewsDetailViewModel(article: article, isFavorite: isFavorite))
    }

    public var body: some View {
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
                FavoriteButton(isFavorite: viewModel.isFavorite) {
                    Task { await viewModel.toggleFavorite() }
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

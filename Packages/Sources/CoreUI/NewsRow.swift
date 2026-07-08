import SwiftUI
import CoreModel
import CoreDesignSystem

public struct NewsRow: View {
    let article: NewsArticle
    let isFavorite: Bool
    let onToggleFavorite: () -> Void

    public init(article: NewsArticle, isFavorite: Bool, onToggleFavorite: @escaping () -> Void) {
        self.article = article
        self.isFavorite = isFavorite
        self.onToggleFavorite = onToggleFavorite
    }

    public var body: some View {
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

            FavoriteButton(isFavorite: isFavorite, action: onToggleFavorite)
        }
        .padding(.vertical, 4)
    }
}

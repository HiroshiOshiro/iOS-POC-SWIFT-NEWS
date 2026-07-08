import Foundation

extension FavoriteArticleEntity {
    func toDomain() -> NewsArticle {
        NewsArticle(
            id: Int(id),
            title: title ?? "",
            url: urlString.flatMap(URL.init(string:)),
            author: author ?? "",
            score: Int(score),
            time: time ?? Date(),
            commentCount: Int(commentCount)
        )
    }
}

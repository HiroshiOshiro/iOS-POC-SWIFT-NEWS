import Foundation

extension NewsItemDTO {
    func toDomain() -> NewsArticle? {
        guard let title else { return nil }
        return NewsArticle(
            id: id,
            title: title,
            url: url.flatMap(URL.init(string:)),
            author: by ?? "unknown",
            score: score ?? 0,
            time: time ?? Date(),
            commentCount: descendants ?? 0
        )
    }
}

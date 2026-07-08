import Foundation

public struct NewsArticle: Identifiable, Equatable, Hashable, Sendable {
    public let id: Int
    public let title: String
    public let url: URL?
    public let author: String
    public let score: Int
    public let time: Date
    public let commentCount: Int

    public init(id: Int, title: String, url: URL?, author: String, score: Int, time: Date, commentCount: Int) {
        self.id = id
        self.title = title
        self.url = url
        self.author = author
        self.score = score
        self.time = time
        self.commentCount = commentCount
    }
}

import Foundation
import CoreModel
import CoreRepository

// テストダブル。テストが構成してから単一タスクで使う前提のため @unchecked Sendable とする。
public final class FakeNewsRepository: NewsRepository, @unchecked Sendable {
    public var articles: [NewsArticle] = []
    public var error: Error?

    public init() {}

    public func fetchTopStories(limit: Int) async throws -> [NewsArticle] {
        if let error { throw error }
        return Array(articles.prefix(limit))
    }
}

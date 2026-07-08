import Foundation
import CoreModel
import CoreRepository

public final class FakeNewsRepository: NewsRepository {
    public var articles: [NewsArticle] = []
    public var error: Error?

    public init() {}

    public func fetchTopStories(limit: Int) async throws -> [NewsArticle] {
        if let error { throw error }
        return Array(articles.prefix(limit))
    }
}

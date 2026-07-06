import Foundation

protocol NewsRepository {
    func fetchTopStories(limit: Int) async throws -> [NewsArticle]
}

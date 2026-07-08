import Foundation
import CoreModel

public protocol NewsRepository {
    func fetchTopStories(limit: Int) async throws -> [NewsArticle]
}

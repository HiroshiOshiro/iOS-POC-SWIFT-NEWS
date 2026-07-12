import Foundation
import CoreModel

public protocol NewsRepository: Sendable {
    func fetchTopStories(limit: Int) async throws -> [NewsArticle]
}

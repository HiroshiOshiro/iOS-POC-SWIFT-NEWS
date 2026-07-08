import Foundation
import CoreModel
import CoreNetwork

public protocol NewsRepository {
    func fetchTopStories(limit: Int) async throws -> [NewsArticle]
}

public final class NewsRepositoryImpl: NewsRepository {
    private let dataSource: HackerNewsNetworkDataSource

    public init(dataSource: HackerNewsNetworkDataSource) {
        self.dataSource = dataSource
    }

    public func fetchTopStories(limit: Int) async throws -> [NewsArticle] {
        let ids = try await dataSource.fetchTopStoryIDs()
        let targetIDs = Array(ids.prefix(limit))
        let dtos = try await dataSource.fetchItems(ids: targetIDs)

        let order = Dictionary(uniqueKeysWithValues: targetIDs.enumerated().map { ($1, $0) })
        return dtos
            .compactMap { $0.toDomain() }
            .sorted { (order[$0.id] ?? 0) < (order[$1.id] ?? 0) }
    }
}

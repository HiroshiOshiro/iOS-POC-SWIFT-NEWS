import Foundation

public protocol HackerNewsNetworkDataSource: Sendable {
    func fetchTopStoryIDs() async throws -> [Int]
    func fetchItems(ids: [Int]) async throws -> [NewsItemDTO]
}

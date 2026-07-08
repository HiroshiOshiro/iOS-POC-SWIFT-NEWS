import Foundation

public protocol HackerNewsNetworkDataSource {
    func fetchTopStoryIDs() async throws -> [Int]
    func fetchItems(ids: [Int]) async throws -> [NewsItemDTO]
}

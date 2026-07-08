import Foundation
import CoreNetwork

public final class FakeHackerNewsNetworkDataSource: HackerNewsNetworkDataSource {
    public var topStoryIDs: [Int] = [1, 2, 3]
    public var items: [Int: NewsItemDTO] = [:]
    public var error: Error?

    public init() {}

    public func fetchTopStoryIDs() async throws -> [Int] {
        if let error { throw error }
        return topStoryIDs
    }

    public func fetchItems(ids: [Int]) async throws -> [NewsItemDTO] {
        if let error { throw error }
        return ids.compactMap { items[$0] }
    }
}

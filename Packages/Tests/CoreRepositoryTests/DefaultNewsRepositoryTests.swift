import XCTest
import CoreNetwork
import CoreTesting
@testable import CoreRepository

final class DefaultNewsRepositoryTests: XCTestCase {
    func testFetchTopStoriesMapsAndSortsByOriginalOrder() async throws {
        let dataSource = FakeHackerNewsNetworkDataSource()
        dataSource.topStoryIDs = [10, 20, 30]
        // itemsを逆順に用意しても、fetchTopStoryIDsの順序でソートされることを確認する
        dataSource.items = [
            10: NewsItemDTO(id: 10, title: "A", url: nil, by: "alice", score: 1, time: Date(), descendants: 0),
            20: NewsItemDTO(id: 20, title: "B", url: nil, by: "bob", score: 2, time: Date(), descendants: 0),
            30: NewsItemDTO(id: 30, title: "C", url: nil, by: "carol", score: 3, time: Date(), descendants: 0),
        ]
        let repository = DefaultNewsRepository(dataSource: dataSource)

        let result = try await repository.fetchTopStories(limit: 3)

        XCTAssertEqual(result.map(\.id), [10, 20, 30])
        XCTAssertEqual(result.map(\.title), ["A", "B", "C"])
    }

    func testFetchTopStoriesSkipsItemsWithoutTitle() async throws {
        let dataSource = FakeHackerNewsNetworkDataSource()
        dataSource.topStoryIDs = [1, 2]
        dataSource.items = [
            1: NewsItemDTO(id: 1, title: nil, url: nil, by: nil, score: nil, time: nil, descendants: nil),
            2: NewsItemDTO(id: 2, title: "Valid", url: nil, by: "dave", score: 5, time: Date(), descendants: 1),
        ]
        let repository = DefaultNewsRepository(dataSource: dataSource)

        let result = try await repository.fetchTopStories(limit: 2)

        XCTAssertEqual(result.map(\.id), [2])
    }

    func testFetchTopStoriesRespectsLimit() async throws {
        let dataSource = FakeHackerNewsNetworkDataSource()
        dataSource.topStoryIDs = [1, 2, 3, 4, 5]
        for id in dataSource.topStoryIDs {
            dataSource.items[id] = NewsItemDTO(id: id, title: "Item \(id)", url: nil, by: "user", score: 0, time: Date(), descendants: 0)
        }
        let repository = DefaultNewsRepository(dataSource: dataSource)

        let result = try await repository.fetchTopStories(limit: 2)

        XCTAssertEqual(result.count, 2)
    }
}

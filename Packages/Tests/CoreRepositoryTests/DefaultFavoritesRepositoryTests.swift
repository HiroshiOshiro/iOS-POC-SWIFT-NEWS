import XCTest
import CoreModel
import CoreDatabase
@testable import CoreRepository

final class DefaultFavoritesRepositoryTests: XCTestCase {
    private func makeArticle(id: Int, title: String = "Title") -> NewsArticle {
        NewsArticle(id: id, title: title, url: nil, author: "author", score: 1, time: Date(), commentCount: 0)
    }

    // RoomのIn-memory DBテストと同様に、実際のCore Dataをインメモリストアで使う
    private func makeRepository() -> DefaultFavoritesRepository {
        DefaultFavoritesRepository(coreDataStack: CoreDataStack(inMemory: true))
    }

    func testAddFavoriteEmitsUpdatedStream() async throws {
        let repository = makeRepository()
        let article = makeArticle(id: 1)

        try await repository.addFavorite(article)

        var iterator = repository.observeFavorites().makeAsyncIterator()
        let favorites = await iterator.next()
        XCTAssertEqual(favorites?.map(\.id), [1])
    }

    func testRemoveFavoriteUpdatesFavoriteIDs() async throws {
        let repository = makeRepository()
        try await repository.addFavorite(makeArticle(id: 1))
        try await repository.addFavorite(makeArticle(id: 2))

        try await repository.removeFavorite(id: 1)

        var iterator = repository.observeFavoriteIDs().makeAsyncIterator()
        let ids = await iterator.next()
        XCTAssertEqual(ids, [2])
    }
}

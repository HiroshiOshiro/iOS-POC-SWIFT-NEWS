import XCTest
import CoreModel
import CoreTesting
@testable import FeatureFavorites

@MainActor
final class FavoritesListViewModelTests: XCTestCase {
    private func makeArticle(id: Int) -> NewsArticle {
        NewsArticle(id: id, title: "Title \(id)", url: nil, author: "author", score: 1, time: Date(), commentCount: 0)
    }

    func testInitialFavoritesAreObservedOnInit() async throws {
        let favoritesRepository = FakeFavoritesRepository(initialFavorites: [makeArticle(id: 1), makeArticle(id: 2)])
        let viewModel = FavoritesListViewModel(favoritesRepository: favoritesRepository)

        try await Task.sleep(nanoseconds: 50_000_000)

        XCTAssertEqual(viewModel.favorites.map(\.id), [1, 2])
    }

    func testRemoveFavoriteUpdatesListReactively() async throws {
        let favoritesRepository = FakeFavoritesRepository(initialFavorites: [makeArticle(id: 1), makeArticle(id: 2)])
        let viewModel = FavoritesListViewModel(favoritesRepository: favoritesRepository)
        try await Task.sleep(nanoseconds: 50_000_000)

        await viewModel.removeFavorite(makeArticle(id: 1))
        try await Task.sleep(nanoseconds: 50_000_000)

        XCTAssertEqual(viewModel.favorites.map(\.id), [2])
    }
}

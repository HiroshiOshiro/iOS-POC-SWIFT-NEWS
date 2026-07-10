import XCTest
import CoreModel
import CoreTesting
@testable import FeatureFavorites

@MainActor
final class FavoritesListViewModelTests: XCTestCase {
    // Date()を都度生成すると呼び出しごとに値が変わりNewsArticleのEquatable比較が失敗するため固定値を使う
    private let fixedDate = Date()

    private func makeArticle(id: Int) -> NewsArticle {
        NewsArticle(id: id, title: "Title \(id)", url: nil, author: "author", score: 1, time: fixedDate, commentCount: 0)
    }

    func testInitialFavoritesAreObservedOnInit() async throws {
        let favoritesRepository = FakeFavoritesRepository(initialFavorites: [makeArticle(id: 1), makeArticle(id: 2)])
        let viewModel = FavoritesListViewModel(favoritesRepository: favoritesRepository)

        try await Task.sleep(nanoseconds: 50_000_000)

        XCTAssertEqual(viewModel.uiState, .success([makeArticle(id: 1), makeArticle(id: 2)]))
    }

    func testEmptyFavoritesProducesEmptyUiState() async throws {
        let favoritesRepository = FakeFavoritesRepository(initialFavorites: [])
        let viewModel = FavoritesListViewModel(favoritesRepository: favoritesRepository)

        try await Task.sleep(nanoseconds: 50_000_000)

        XCTAssertEqual(viewModel.uiState, .empty)
    }

    func testRemoveFavoriteUpdatesListReactively() async throws {
        let favoritesRepository = FakeFavoritesRepository(initialFavorites: [makeArticle(id: 1), makeArticle(id: 2)])
        let viewModel = FavoritesListViewModel(favoritesRepository: favoritesRepository)
        try await Task.sleep(nanoseconds: 50_000_000)

        await viewModel.removeFavorite(makeArticle(id: 1))
        try await Task.sleep(nanoseconds: 50_000_000)

        XCTAssertEqual(viewModel.uiState, .success([makeArticle(id: 2)]))
    }
}

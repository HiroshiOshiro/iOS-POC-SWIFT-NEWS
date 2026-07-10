import XCTest
import CoreModel
import CoreTesting
@testable import FeatureNews

@MainActor
final class NewsListViewModelTests: XCTestCase {
    // Date()を都度生成すると呼び出しごとに値が変わりNewsArticleのEquatable比較が失敗するため固定値を使う
    private let fixedDate = Date()

    private func makeArticle(id: Int) -> NewsArticle {
        NewsArticle(id: id, title: "Title \(id)", url: nil, author: "author", score: 1, time: fixedDate, commentCount: 0)
    }

    func testLoadPopulatesArticles() async throws {
        let newsRepository = FakeNewsRepository()
        newsRepository.articles = [makeArticle(id: 1), makeArticle(id: 2)]
        let viewModel = NewsListViewModel(newsRepository: newsRepository, favoritesRepository: FakeFavoritesRepository())

        await viewModel.load()

        XCTAssertEqual(viewModel.uiState, .success([makeArticle(id: 1), makeArticle(id: 2)]))
    }

    func testToggleFavoriteReflectsFavoritesRepositoryStream() async throws {
        let newsRepository = FakeNewsRepository()
        let article = makeArticle(id: 1)
        newsRepository.articles = [article]
        let favoritesRepository = FakeFavoritesRepository()
        let viewModel = NewsListViewModel(newsRepository: newsRepository, favoritesRepository: favoritesRepository)
        await viewModel.load()

        await viewModel.toggleFavorite(article)
        try await Task.sleep(nanoseconds: 50_000_000)

        XCTAssertTrue(viewModel.isFavorite(article))
    }

    func testLoadFailureSetsFailureUiState() async throws {
        let newsRepository = FakeNewsRepository()
        newsRepository.error = URLError(.notConnectedToInternet)
        let viewModel = NewsListViewModel(newsRepository: newsRepository, favoritesRepository: FakeFavoritesRepository())

        await viewModel.load()

        guard case .failure = viewModel.uiState else {
            return XCTFail("Expected .failure state, got \(viewModel.uiState)")
        }
    }
}

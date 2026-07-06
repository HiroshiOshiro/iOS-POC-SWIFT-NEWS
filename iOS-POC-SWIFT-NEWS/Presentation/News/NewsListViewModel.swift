import Foundation

@MainActor
final class NewsListViewModel: ObservableObject {
    @Published private(set) var articles: [NewsArticle] = []
    @Published private(set) var favoriteIDs: Set<Int> = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let fetchTopNewsUseCase: FetchTopNewsUseCase
    private let fetchFavoriteIDsUseCase: FetchFavoriteIDsUseCase
    private let toggleFavoriteUseCase: ToggleFavoriteUseCase

    init(
        fetchTopNewsUseCase: FetchTopNewsUseCase,
        fetchFavoriteIDsUseCase: FetchFavoriteIDsUseCase,
        toggleFavoriteUseCase: ToggleFavoriteUseCase
    ) {
        self.fetchTopNewsUseCase = fetchTopNewsUseCase
        self.fetchFavoriteIDsUseCase = fetchFavoriteIDsUseCase
        self.toggleFavoriteUseCase = toggleFavoriteUseCase
    }

    func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            async let articlesResult = fetchTopNewsUseCase.execute(limit: 30)
            async let favoriteIDsResult = fetchFavoriteIDsUseCase.execute()
            articles = try await articlesResult
            favoriteIDs = try await favoriteIDsResult
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func isFavorite(_ article: NewsArticle) -> Bool {
        favoriteIDs.contains(article.id)
    }

    func toggleFavorite(_ article: NewsArticle) async {
        let currentlyFavorite = isFavorite(article)
        do {
            try await toggleFavoriteUseCase.execute(article: article, isCurrentlyFavorite: currentlyFavorite)
            if currentlyFavorite {
                favoriteIDs.remove(article.id)
            } else {
                favoriteIDs.insert(article.id)
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

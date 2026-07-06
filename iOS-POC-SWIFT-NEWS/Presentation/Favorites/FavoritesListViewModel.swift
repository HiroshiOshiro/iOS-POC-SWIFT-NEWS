import Foundation

@MainActor
final class FavoritesListViewModel: ObservableObject {
    @Published private(set) var favorites: [NewsArticle] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let fetchFavoritesUseCase: FetchFavoritesUseCase
    private let toggleFavoriteUseCase: ToggleFavoriteUseCase

    init(fetchFavoritesUseCase: FetchFavoritesUseCase, toggleFavoriteUseCase: ToggleFavoriteUseCase) {
        self.fetchFavoritesUseCase = fetchFavoritesUseCase
        self.toggleFavoriteUseCase = toggleFavoriteUseCase
    }

    func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            favorites = try await fetchFavoritesUseCase.execute()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func removeFavorite(_ article: NewsArticle) async {
        do {
            try await toggleFavoriteUseCase.execute(article: article, isCurrentlyFavorite: true)
            favorites.removeAll { $0.id == article.id }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

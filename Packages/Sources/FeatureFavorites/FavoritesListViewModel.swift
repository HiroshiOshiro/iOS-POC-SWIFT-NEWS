import Foundation
import CoreModel
import CoreRepository

@MainActor
public final class FavoritesListViewModel: ObservableObject {
    @Published public private(set) var favorites: [NewsArticle] = []
    @Published public private(set) var isLoading = false
    @Published public var errorMessage: String?

    private let favoritesRepository: FavoritesRepository

    public init(favoritesRepository: FavoritesRepository) {
        self.favoritesRepository = favoritesRepository
    }

    public func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            favorites = try await favoritesRepository.fetchAllFavorites()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    public func removeFavorite(_ article: NewsArticle) async {
        do {
            try await favoritesRepository.removeFavorite(id: article.id)
            favorites.removeAll { $0.id == article.id }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

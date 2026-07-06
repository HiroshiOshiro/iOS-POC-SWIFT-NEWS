import Foundation

protocol ToggleFavoriteUseCase {
    func execute(article: NewsArticle, isCurrentlyFavorite: Bool) async throws
}

struct ToggleFavoriteUseCaseImpl: ToggleFavoriteUseCase {
    let favoritesRepository: FavoritesRepository

    func execute(article: NewsArticle, isCurrentlyFavorite: Bool) async throws {
        if isCurrentlyFavorite {
            try await favoritesRepository.removeFavorite(id: article.id)
        } else {
            try await favoritesRepository.addFavorite(article)
        }
    }
}

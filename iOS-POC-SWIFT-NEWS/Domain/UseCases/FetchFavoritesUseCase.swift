import Foundation

protocol FetchFavoritesUseCase {
    func execute() async throws -> [NewsArticle]
}

struct FetchFavoritesUseCaseImpl: FetchFavoritesUseCase {
    let favoritesRepository: FavoritesRepository

    func execute() async throws -> [NewsArticle] {
        try await favoritesRepository.fetchAllFavorites()
    }
}

protocol FetchFavoriteIDsUseCase {
    func execute() async throws -> Set<Int>
}

struct FetchFavoriteIDsUseCaseImpl: FetchFavoriteIDsUseCase {
    let favoritesRepository: FavoritesRepository

    func execute() async throws -> Set<Int> {
        try await favoritesRepository.fetchFavoriteIDs()
    }
}

import Foundation

protocol FavoritesRepository {
    func fetchAllFavorites() async throws -> [NewsArticle]
    func fetchFavoriteIDs() async throws -> Set<Int>
    func addFavorite(_ article: NewsArticle) async throws
    func removeFavorite(id: Int) async throws
}

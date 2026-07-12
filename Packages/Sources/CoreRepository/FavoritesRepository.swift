import Foundation
import CoreModel

public protocol FavoritesRepository: Sendable {
    // NiAのFlow<List<NewsResource>>に相当。呼び出し側は継続的に最新状態を受け取れる
    func observeFavorites() -> AsyncStream<[NewsArticle]>
    func observeFavoriteIDs() -> AsyncStream<Set<Int>>
    func addFavorite(_ article: NewsArticle) async throws
    func removeFavorite(id: Int) async throws
}

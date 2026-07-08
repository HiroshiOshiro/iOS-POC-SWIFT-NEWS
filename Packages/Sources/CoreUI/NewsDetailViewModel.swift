import Foundation
import CoreModel
import CoreRepository

@MainActor
public final class NewsDetailViewModel: ObservableObject {
    public let article: NewsArticle
    @Published public private(set) var isFavorite: Bool
    @Published public var errorMessage: String?

    private let favoritesRepository: FavoritesRepository

    public init(article: NewsArticle, isFavorite: Bool, favoritesRepository: FavoritesRepository) {
        self.article = article
        self.isFavorite = isFavorite
        self.favoritesRepository = favoritesRepository
    }

    public func toggleFavorite() async {
        do {
            if isFavorite {
                try await favoritesRepository.removeFavorite(id: article.id)
            } else {
                try await favoritesRepository.addFavorite(article)
            }
            isFavorite.toggle()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

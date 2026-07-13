import Foundation
import Factory
import CoreModel
import CoreRepository

@MainActor
public final class NewsDetailViewModel: ObservableObject {
    public let article: NewsArticle
    @Published public private(set) var isFavorite: Bool
    @Published public var errorMessage: String?

    @Injected(\.favoritesRepository) private var favoritesRepository: FavoritesRepository

    public init(article: NewsArticle, isFavorite: Bool) {
        self.article = article
        self.isFavorite = isFavorite
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

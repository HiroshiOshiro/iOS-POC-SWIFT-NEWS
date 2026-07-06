import Foundation

@MainActor
final class NewsDetailViewModel: ObservableObject {
    let article: NewsArticle
    @Published private(set) var isFavorite: Bool
    @Published var errorMessage: String?

    private let toggleFavoriteUseCase: ToggleFavoriteUseCase

    init(article: NewsArticle, isFavorite: Bool, toggleFavoriteUseCase: ToggleFavoriteUseCase) {
        self.article = article
        self.isFavorite = isFavorite
        self.toggleFavoriteUseCase = toggleFavoriteUseCase
    }

    func toggleFavorite() async {
        do {
            try await toggleFavoriteUseCase.execute(article: article, isCurrentlyFavorite: isFavorite)
            isFavorite.toggle()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

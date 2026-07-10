import Foundation
import CoreModel
import CoreRepository

@MainActor
public final class FavoritesListViewModel: ObservableObject {
    @Published public private(set) var uiState: FavoritesUiState = .loading
    @Published public var errorMessage: String?

    private let favoritesRepository: FavoritesRepository
    private var observeTask: Task<Void, Never>?

    public init(favoritesRepository: FavoritesRepository) {
        self.favoritesRepository = favoritesRepository
        observeTask = Task { [weak self] in
            guard let self else { return }
            for await favorites in favoritesRepository.observeFavorites() {
                self.uiState = favorites.isEmpty ? .empty : .success(favorites)
            }
        }
    }

    deinit {
        observeTask?.cancel()
    }

    public func removeFavorite(_ article: NewsArticle) async {
        do {
            try await favoritesRepository.removeFavorite(id: article.id)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

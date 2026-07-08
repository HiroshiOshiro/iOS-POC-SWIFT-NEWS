import Foundation
import CoreModel
import CoreRepository

@MainActor
public final class NewsListViewModel: ObservableObject {
    @Published public private(set) var articles: [NewsArticle] = []
    @Published public private(set) var favoriteIDs: Set<Int> = []
    @Published public private(set) var isLoading = false
    @Published public var errorMessage: String?

    private let newsRepository: NewsRepository
    private let favoritesRepository: FavoritesRepository
    private var observeFavoriteIDsTask: Task<Void, Never>?

    public init(newsRepository: NewsRepository, favoritesRepository: FavoritesRepository) {
        self.newsRepository = newsRepository
        self.favoritesRepository = favoritesRepository
        observeFavoriteIDsTask = Task { [weak self] in
            guard let self else { return }
            for await ids in favoritesRepository.observeFavoriteIDs() {
                self.favoriteIDs = ids
            }
        }
    }

    deinit {
        observeFavoriteIDsTask?.cancel()
    }

    public func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            articles = try await newsRepository.fetchTopStories(limit: 30)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    public func isFavorite(_ article: NewsArticle) -> Bool {
        favoriteIDs.contains(article.id)
    }

    public func toggleFavorite(_ article: NewsArticle) async {
        do {
            if isFavorite(article) {
                try await favoritesRepository.removeFavorite(id: article.id)
            } else {
                try await favoritesRepository.addFavorite(article)
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

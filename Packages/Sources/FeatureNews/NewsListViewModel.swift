import Foundation
import CoreModel
import CoreRepository

@MainActor
public final class NewsListViewModel: ObservableObject {
    @Published public private(set) var uiState: NewsListUiState = .loading
    // お気に入り状態はページ読み込みとは独立して継続的に変化するため、
    // uiStateには含めずFavoritesRepositoryのストリームを直接反映する
    @Published public private(set) var favoriteIDs: Set<Int> = []
    // お気に入りトグル失敗など一過性のイベント用。uiStateとは別チャンネルで扱う(NiAのSnackbarメッセージ相当)
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
        uiState = .loading
        do {
            let articles = try await newsRepository.fetchTopStories(limit: 30)
            uiState = .success(articles)
        } catch {
            uiState = .failure(error.localizedDescription)
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

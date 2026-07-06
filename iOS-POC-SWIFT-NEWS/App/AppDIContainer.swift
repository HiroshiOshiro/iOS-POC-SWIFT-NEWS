import Foundation

@MainActor
final class AppDIContainer {
    private let networkService = NetworkService()
    private let coreDataStack = CoreDataStack()

    private lazy var newsRepository: NewsRepository = HackerNewsAPIClient(networkService: networkService)
    private lazy var favoritesRepository: FavoritesRepository = FavoritesRepositoryImpl(coreDataStack: coreDataStack)
    private lazy var authRepository: AuthRepository = AuthAPIClient()

    private lazy var fetchTopNewsUseCase: FetchTopNewsUseCase = FetchTopNewsUseCaseImpl(newsRepository: newsRepository)
    private lazy var fetchFavoriteIDsUseCase: FetchFavoriteIDsUseCase = FetchFavoriteIDsUseCaseImpl(favoritesRepository: favoritesRepository)
    private lazy var fetchFavoritesUseCase: FetchFavoritesUseCase = FetchFavoritesUseCaseImpl(favoritesRepository: favoritesRepository)
    private lazy var toggleFavoriteUseCase: ToggleFavoriteUseCase = ToggleFavoriteUseCaseImpl(favoritesRepository: favoritesRepository)
    private lazy var loginUseCase: LoginUseCase = LoginUseCaseImpl(authRepository: authRepository)

    func makeNewsListViewModel() -> NewsListViewModel {
        NewsListViewModel(
            fetchTopNewsUseCase: fetchTopNewsUseCase,
            fetchFavoriteIDsUseCase: fetchFavoriteIDsUseCase,
            toggleFavoriteUseCase: toggleFavoriteUseCase
        )
    }

    func makeFavoritesListViewModel() -> FavoritesListViewModel {
        FavoritesListViewModel(
            fetchFavoritesUseCase: fetchFavoritesUseCase,
            toggleFavoriteUseCase: toggleFavoriteUseCase
        )
    }

    func makeNewsDetailViewModel(article: NewsArticle, isFavorite: Bool) -> NewsDetailViewModel {
        NewsDetailViewModel(
            article: article,
            isFavorite: isFavorite,
            toggleFavoriteUseCase: toggleFavoriteUseCase
        )
    }

    func makeLoginViewModel() -> LoginViewModel {
        LoginViewModel(loginUseCase: loginUseCase)
    }
}

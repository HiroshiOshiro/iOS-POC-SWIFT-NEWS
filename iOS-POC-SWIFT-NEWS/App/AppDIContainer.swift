import Foundation
import CoreNetwork
import CoreDatabase
import CoreRepository

@MainActor
final class AppDIContainer {
    private let networkService = NetworkService()
    private let coreDataStack = CoreDataStack()

    lazy var newsRepository: NewsRepository = NewsRepositoryImpl(
        dataSource: HackerNewsNetworkDataSource(networkService: networkService)
    )
    lazy var favoritesRepository: FavoritesRepository = FavoritesRepositoryImpl(coreDataStack: coreDataStack)
    lazy var authRepository: AuthRepository = AuthRepositoryImpl(dataSource: AuthNetworkDataSource())
}

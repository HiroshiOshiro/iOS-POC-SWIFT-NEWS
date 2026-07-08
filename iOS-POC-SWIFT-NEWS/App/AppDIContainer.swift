import Foundation
import CoreNetwork
import CoreDatabase
import CoreDataStore
import CoreRepository

@MainActor
final class AppDIContainer {
    private let networkService = NetworkService()
    private let coreDataStack = CoreDataStack()

    lazy var newsRepository: NewsRepository = DefaultNewsRepository(
        dataSource: DefaultHackerNewsNetworkDataSource(networkService: networkService)
    )
    lazy var favoritesRepository: FavoritesRepository = DefaultFavoritesRepository(coreDataStack: coreDataStack)
    lazy var authRepository: AuthRepository = DefaultAuthRepository(dataSource: DefaultAuthNetworkDataSource())
    lazy var userDataRepository: UserDataRepository = DefaultUserDataRepository(
        dataSource: UserDefaultsPreferencesDataSource()
    )
}

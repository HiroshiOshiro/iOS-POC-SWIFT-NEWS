import Factory
import CoreNetwork
import CoreDatabase
import CoreDataStore

// FactoryのContainerにRepositoryを登録する。NiAのHiltモジュール(@Provides)に相当し、
// 実装の組み立てを1箇所に集約する。.singletonでCoreDataStack/UserDefaultsの
// インスタンスがアプリ全体で1つだけ生成されるようにする。
public extension Container {
    var newsRepository: Factory<NewsRepository> {
        self {
            DefaultNewsRepository(dataSource: DefaultHackerNewsNetworkDataSource(networkService: NetworkService()))
        }
        .singleton
    }

    var favoritesRepository: Factory<FavoritesRepository> {
        self { DefaultFavoritesRepository(coreDataStack: CoreDataStack()) }
            .singleton
    }

    var authRepository: Factory<AuthRepository> {
        self { DefaultAuthRepository(dataSource: DefaultAuthNetworkDataSource()) }
            .singleton
    }

    var userDataRepository: Factory<UserDataRepository> {
        self { DefaultUserDataRepository(dataSource: UserDefaultsPreferencesDataSource()) }
            .singleton
    }
}

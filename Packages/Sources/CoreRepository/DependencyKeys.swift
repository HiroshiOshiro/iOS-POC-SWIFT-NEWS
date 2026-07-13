import Dependencies
import CoreNetwork
import CoreDatabase
import CoreDataStore

// swift-dependenciesのDependencyKeyとしてRepositoryを登録する。
// liveValueはNiAのHiltモジュール(@Provides)に相当し、実装の組み立てを1箇所に集約する。
// testValueはliveValueへのフォールバックだが、テストでは常にwithDependencies(...)で
// CoreTestingのFakeへ明示的に差し替えるため実際に使われることはない。

private enum NewsRepositoryKey: DependencyKey {
    static let liveValue: NewsRepository = DefaultNewsRepository(
        dataSource: DefaultHackerNewsNetworkDataSource(networkService: NetworkService())
    )
    static let testValue: NewsRepository = liveValue
}

private enum FavoritesRepositoryKey: DependencyKey {
    static let liveValue: FavoritesRepository = DefaultFavoritesRepository(coreDataStack: CoreDataStack())
    static let testValue: FavoritesRepository = liveValue
}

private enum AuthRepositoryKey: DependencyKey {
    static let liveValue: AuthRepository = DefaultAuthRepository(dataSource: DefaultAuthNetworkDataSource())
    static let testValue: AuthRepository = liveValue
}

private enum UserDataRepositoryKey: DependencyKey {
    static let liveValue: UserDataRepository = DefaultUserDataRepository(
        dataSource: UserDefaultsPreferencesDataSource()
    )
    static let testValue: UserDataRepository = liveValue
}

public extension DependencyValues {
    var newsRepository: NewsRepository {
        get { self[NewsRepositoryKey.self] }
        set { self[NewsRepositoryKey.self] = newValue }
    }

    var favoritesRepository: FavoritesRepository {
        get { self[FavoritesRepositoryKey.self] }
        set { self[FavoritesRepositoryKey.self] = newValue }
    }

    var authRepository: AuthRepository {
        get { self[AuthRepositoryKey.self] }
        set { self[AuthRepositoryKey.self] = newValue }
    }

    var userDataRepository: UserDataRepository {
        get { self[UserDataRepositoryKey.self] }
        set { self[UserDataRepositoryKey.self] = newValue }
    }
}

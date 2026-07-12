import Foundation
import CoreData
import CoreModel
import CoreDatabase

public final class DefaultFavoritesRepository: FavoritesRepository, @unchecked Sendable {
    private let coreDataStack: CoreDataStack

    // 配信状態はロックで保護する。Combine は使わず AsyncStream で多重配信する。
    private let lock = NSLock()
    private var current: [NewsArticle] = []
    private var favoriteContinuations: [UUID: AsyncStream<[NewsArticle]>.Continuation] = [:]
    private var favoriteIDContinuations: [UUID: AsyncStream<Set<Int>>.Continuation] = [:]

    public init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        Task { await refresh() }
    }

    public func observeFavorites() -> AsyncStream<[NewsArticle]> {
        AsyncStream { continuation in
            let id = UUID()
            lock.lock()
            favoriteContinuations[id] = continuation
            let value = current
            lock.unlock()

            continuation.yield(value)

            continuation.onTermination = { [weak self] _ in
                guard let self else { return }
                lock.lock()
                favoriteContinuations[id] = nil
                lock.unlock()
            }
        }
    }

    public func observeFavoriteIDs() -> AsyncStream<Set<Int>> {
        AsyncStream { continuation in
            let id = UUID()
            lock.lock()
            favoriteIDContinuations[id] = continuation
            let value = Set(current.map(\.id))
            lock.unlock()

            continuation.yield(value)

            continuation.onTermination = { [weak self] _ in
                guard let self else { return }
                lock.lock()
                favoriteIDContinuations[id] = nil
                lock.unlock()
            }
        }
    }

    public func addFavorite(_ article: NewsArticle) async throws {
        let context = coreDataStack.newBackgroundContext()
        try await context.perform {
            let entity = FavoriteArticleEntity(context: context)
            entity.id = Int64(article.id)
            entity.title = article.title
            entity.urlString = article.url?.absoluteString
            entity.author = article.author
            entity.score = Int32(article.score)
            entity.time = article.time
            entity.commentCount = Int32(article.commentCount)
            entity.savedAt = Date()
            try context.save()
        }
        await refresh()
    }

    public func removeFavorite(id: Int) async throws {
        let context = coreDataStack.newBackgroundContext()
        try await context.perform {
            let request = FavoriteArticleEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", id)
            for entity in try context.fetch(request) {
                context.delete(entity)
            }
            try context.save()
        }
        await refresh()
    }

    private func refresh() async {
        let context = coreDataStack.newBackgroundContext()
        guard let favorites = try? await context.perform({
            let request = FavoriteArticleEntity.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "savedAt", ascending: false)]
            return try context.fetch(request).map { $0.toDomain() }
        }) else {
            return
        }
        publish(favorites)
    }

    // ロック区間は同期メソッドに閉じ込める（NSLock は async 文脈から直接呼べないため）。
    private func publish(_ favorites: [NewsArticle]) {
        lock.lock()
        current = favorites
        let favoriteTargets = Array(favoriteContinuations.values)
        let idTargets = Array(favoriteIDContinuations.values)
        lock.unlock()

        let ids = Set(favorites.map(\.id))
        for continuation in favoriteTargets {
            continuation.yield(favorites)
        }
        for continuation in idTargets {
            continuation.yield(ids)
        }
    }
}

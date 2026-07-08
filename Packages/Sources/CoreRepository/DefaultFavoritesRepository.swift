import Foundation
import Combine
import CoreData
import CoreModel
import CoreDatabase

public final class DefaultFavoritesRepository: FavoritesRepository {
    private let coreDataStack: CoreDataStack
    private let favoritesSubject = CurrentValueSubject<[NewsArticle], Never>([])

    public init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        Task { await refresh() }
    }

    public func observeFavorites() -> AsyncStream<[NewsArticle]> {
        AsyncStream { continuation in
            let cancellable = favoritesSubject.sink { continuation.yield($0) }
            continuation.onTermination = { _ in cancellable.cancel() }
        }
    }

    public func observeFavoriteIDs() -> AsyncStream<Set<Int>> {
        AsyncStream { continuation in
            let cancellable = favoritesSubject
                .map { Set($0.map(\.id)) }
                .sink { continuation.yield($0) }
            continuation.onTermination = { _ in cancellable.cancel() }
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
        favoritesSubject.send(favorites)
    }
}

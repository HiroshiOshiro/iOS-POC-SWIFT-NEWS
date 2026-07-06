import CoreData

final class FavoritesRepositoryImpl: FavoritesRepository {
    private let coreDataStack: CoreDataStack

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }

    func fetchAllFavorites() async throws -> [NewsArticle] {
        let context = coreDataStack.newBackgroundContext()
        return try await context.perform {
            let request = FavoriteArticleEntity.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "savedAt", ascending: false)]
            return try context.fetch(request).map { $0.toDomain() }
        }
    }

    func fetchFavoriteIDs() async throws -> Set<Int> {
        let context = coreDataStack.newBackgroundContext()
        return try await context.perform {
            let request = FavoriteArticleEntity.fetchRequest()
            let ids = try context.fetch(request).map { Int($0.id) }
            return Set(ids)
        }
    }

    func addFavorite(_ article: NewsArticle) async throws {
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
    }

    func removeFavorite(id: Int) async throws {
        let context = coreDataStack.newBackgroundContext()
        try await context.perform {
            let request = FavoriteArticleEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", id)
            for entity in try context.fetch(request) {
                context.delete(entity)
            }
            try context.save()
        }
    }
}

private extension FavoriteArticleEntity {
    func toDomain() -> NewsArticle {
        NewsArticle(
            id: Int(id),
            title: title ?? "",
            url: urlString.flatMap(URL.init(string:)),
            author: author ?? "",
            score: Int(score),
            time: time ?? Date(),
            commentCount: Int(commentCount)
        )
    }
}

import Foundation
import Combine
import CoreModel
import CoreRepository

// Core Dataを使わないインメモリFake。AsyncStreamの購読も本物同様に検証できる。
public final class FakeFavoritesRepository: FavoritesRepository {
    private let subject: CurrentValueSubject<[NewsArticle], Never>

    public init(initialFavorites: [NewsArticle] = []) {
        subject = CurrentValueSubject(initialFavorites)
    }

    public func observeFavorites() -> AsyncStream<[NewsArticle]> {
        AsyncStream { continuation in
            let cancellable = subject.sink { continuation.yield($0) }
            continuation.onTermination = { _ in cancellable.cancel() }
        }
    }

    public func observeFavoriteIDs() -> AsyncStream<Set<Int>> {
        AsyncStream { continuation in
            let cancellable = subject
                .map { Set($0.map(\.id)) }
                .sink { continuation.yield($0) }
            continuation.onTermination = { _ in cancellable.cancel() }
        }
    }

    public func addFavorite(_ article: NewsArticle) async throws {
        var current = subject.value
        current.removeAll { $0.id == article.id }
        current.insert(article, at: 0)
        subject.send(current)
    }

    public func removeFavorite(id: Int) async throws {
        var current = subject.value
        current.removeAll { $0.id == id }
        subject.send(current)
    }
}

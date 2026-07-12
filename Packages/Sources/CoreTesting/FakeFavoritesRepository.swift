import Foundation
import CoreModel
import CoreRepository

// Core Dataを使わないインメモリFake。AsyncStreamの購読も本物同様に検証できる。
// Combine は使わず、ロックで保護した継続への多重配信で実装する。
public final class FakeFavoritesRepository: FavoritesRepository, @unchecked Sendable {
    private let lock = NSLock()
    private var current: [NewsArticle]
    private var favoriteContinuations: [UUID: AsyncStream<[NewsArticle]>.Continuation] = [:]
    private var favoriteIDContinuations: [UUID: AsyncStream<Set<Int>>.Continuation] = [:]

    public init(initialFavorites: [NewsArticle] = []) {
        current = initialFavorites
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
        publish(mutate { current in
            current.removeAll { $0.id == article.id }
            current.insert(article, at: 0)
        })
    }

    public func removeFavorite(id: Int) async throws {
        publish(mutate { current in
            current.removeAll { $0.id == id }
        })
    }

    // ロック区間は同期メソッドに閉じ込める（NSLock は async 文脈から直接呼べないため）。
    private func mutate(_ change: (inout [NewsArticle]) -> Void) -> [NewsArticle] {
        lock.lock()
        change(&current)
        let snapshot = current
        lock.unlock()
        return snapshot
    }

    private func publish(_ favorites: [NewsArticle]) {
        lock.lock()
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

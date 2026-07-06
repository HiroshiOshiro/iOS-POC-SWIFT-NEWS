import Foundation

protocol FetchTopNewsUseCase {
    func execute(limit: Int) async throws -> [NewsArticle]
}

struct FetchTopNewsUseCaseImpl: FetchTopNewsUseCase {
    let newsRepository: NewsRepository

    func execute(limit: Int) async throws -> [NewsArticle] {
        try await newsRepository.fetchTopStories(limit: limit)
    }
}

import Foundation

private struct HNItemDTO: Decodable {
    let id: Int
    let title: String?
    let url: String?
    let by: String?
    let score: Int?
    let time: Date?
    let descendants: Int?
}

private enum HackerNewsEndpoint: Endpoint {
    case topStories
    case item(id: Int)

    var url: URL {
        switch self {
        case .topStories:
            return URL(string: "https://hacker-news.firebaseio.com/v0/topstories.json")!
        case .item(let id):
            return URL(string: "https://hacker-news.firebaseio.com/v0/item/\(id).json")!
        }
    }
}

final class HackerNewsAPIClient: NewsRepository {
    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func fetchTopStories(limit: Int) async throws -> [NewsArticle] {
        let ids: [Int] = try await networkService.request(HackerNewsEndpoint.topStories)
        let targetIDs = Array(ids.prefix(limit))

        let articles: [NewsArticle] = try await withThrowingTaskGroup(of: NewsArticle?.self) { group in
            for id in targetIDs {
                group.addTask { [networkService] in
                    let dto: HNItemDTO = try await networkService.request(HackerNewsEndpoint.item(id: id))
                    guard let title = dto.title else { return nil }
                    return NewsArticle(
                        id: dto.id,
                        title: title,
                        url: dto.url.flatMap(URL.init(string:)),
                        author: dto.by ?? "unknown",
                        score: dto.score ?? 0,
                        time: dto.time ?? Date(),
                        commentCount: dto.descendants ?? 0
                    )
                }
            }

            var results: [NewsArticle] = []
            for try await article in group {
                if let article {
                    results.append(article)
                }
            }
            return results
        }

        let order = Dictionary(uniqueKeysWithValues: targetIDs.enumerated().map { ($1, $0) })
        return articles.sorted { (order[$0.id] ?? 0) < (order[$1.id] ?? 0) }
    }
}

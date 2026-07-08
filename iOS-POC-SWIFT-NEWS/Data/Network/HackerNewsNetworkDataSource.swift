import Foundation

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

final class HackerNewsNetworkDataSource {
    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func fetchTopStoryIDs() async throws -> [Int] {
        try await networkService.request(HackerNewsEndpoint.topStories)
    }

    func fetchItems(ids: [Int]) async throws -> [NewsItemDTO] {
        try await withThrowingTaskGroup(of: NewsItemDTO.self) { group in
            for id in ids {
                group.addTask { [networkService] in
                    try await networkService.request(HackerNewsEndpoint.item(id: id))
                }
            }

            var results: [NewsItemDTO] = []
            for try await dto in group {
                results.append(dto)
            }
            return results
        }
    }
}

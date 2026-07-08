import Foundation

public struct NewsItemDTO: Decodable {
    public let id: Int
    public let title: String?
    public let url: String?
    public let by: String?
    public let score: Int?
    public let time: Date?
    public let descendants: Int?

    public init(id: Int, title: String?, url: String?, by: String?, score: Int?, time: Date?, descendants: Int?) {
        self.id = id
        self.title = title
        self.url = url
        self.by = by
        self.score = score
        self.time = time
        self.descendants = descendants
    }
}

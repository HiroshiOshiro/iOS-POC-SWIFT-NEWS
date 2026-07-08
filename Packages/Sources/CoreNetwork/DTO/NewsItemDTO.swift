import Foundation

public struct NewsItemDTO: Decodable {
    public let id: Int
    public let title: String?
    public let url: String?
    public let by: String?
    public let score: Int?
    public let time: Date?
    public let descendants: Int?
}

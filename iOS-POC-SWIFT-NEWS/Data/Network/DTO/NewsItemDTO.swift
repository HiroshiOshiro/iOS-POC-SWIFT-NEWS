import Foundation

struct NewsItemDTO: Decodable {
    let id: Int
    let title: String?
    let url: String?
    let by: String?
    let score: Int?
    let time: Date?
    let descendants: Int?
}

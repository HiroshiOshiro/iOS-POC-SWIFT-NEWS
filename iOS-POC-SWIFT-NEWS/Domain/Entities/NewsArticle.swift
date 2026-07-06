import Foundation

struct NewsArticle: Identifiable, Equatable, Hashable {
    let id: Int
    let title: String
    let url: URL?
    let author: String
    let score: Int
    let time: Date
    let commentCount: Int
}

import Foundation

// UserDefaultsに保存する生データ。core:datastoreはドメインモデルを知らない。
public struct UserPreferences: Equatable {
    public let isLoggedIn: Bool
    public let userID: String
    public let userName: String
    public let userEmail: String

    public init(isLoggedIn: Bool, userID: String, userName: String, userEmail: String) {
        self.isLoggedIn = isLoggedIn
        self.userID = userID
        self.userName = userName
        self.userEmail = userEmail
    }

    public static let empty = UserPreferences(isLoggedIn: false, userID: "", userName: "", userEmail: "")
}

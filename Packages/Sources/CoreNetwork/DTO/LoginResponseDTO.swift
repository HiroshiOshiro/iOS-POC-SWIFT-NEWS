import Foundation

public struct LoginResponseDTO: Decodable {
    public let id: String
    public let name: String
    public let email: String
}

import Foundation

public protocol AuthNetworkDataSource: Sendable {
    func login(email: String, password: String) async throws -> LoginResponseDTO
}

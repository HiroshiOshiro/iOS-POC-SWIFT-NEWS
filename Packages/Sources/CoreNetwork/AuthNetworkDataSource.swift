import Foundation

public protocol AuthNetworkDataSource {
    func login(email: String, password: String) async throws -> LoginResponseDTO
}

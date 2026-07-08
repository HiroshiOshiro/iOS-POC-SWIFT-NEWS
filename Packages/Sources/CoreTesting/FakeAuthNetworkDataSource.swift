import Foundation
import CoreNetwork

public final class FakeAuthNetworkDataSource: AuthNetworkDataSource {
    public var result: Result<LoginResponseDTO, Error> = .failure(NetworkError.httpStatus(401))

    public init() {}

    public func login(email: String, password: String) async throws -> LoginResponseDTO {
        try result.get()
    }
}

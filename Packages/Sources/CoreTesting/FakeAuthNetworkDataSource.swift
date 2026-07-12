import Foundation
import CoreNetwork

// テストダブル。テストが構成してから単一タスクで使う前提のため @unchecked Sendable とする。
public final class FakeAuthNetworkDataSource: AuthNetworkDataSource, @unchecked Sendable {
    public var result: Result<LoginResponseDTO, Error> = .failure(NetworkError.httpStatus(401))

    public init() {}

    public func login(email: String, password: String) async throws -> LoginResponseDTO {
        try result.get()
    }
}

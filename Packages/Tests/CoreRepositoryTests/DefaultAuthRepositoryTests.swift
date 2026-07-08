import XCTest
import CoreNetwork
import CoreTesting
@testable import CoreRepository

final class DefaultAuthRepositoryTests: XCTestCase {
    func testLoginSuccessMapsToDomainUser() async throws {
        let dataSource = FakeAuthNetworkDataSource()
        dataSource.result = .success(LoginResponseDTO(id: "1", name: "Taro Yamada", email: "taro@example.com"))
        let repository = DefaultAuthRepository(dataSource: dataSource)

        let user = try await repository.login(email: "taro@example.com", password: "password123")

        XCTAssertEqual(user.id, "1")
        XCTAssertEqual(user.name, "Taro Yamada")
        XCTAssertEqual(user.email, "taro@example.com")
    }

    func testLoginFailureTranslates401ToInvalidCredentials() async throws {
        let dataSource = FakeAuthNetworkDataSource()
        dataSource.result = .failure(NetworkError.httpStatus(401))
        let repository = DefaultAuthRepository(dataSource: dataSource)

        do {
            _ = try await repository.login(email: "wrong@example.com", password: "short")
            XCTFail("Expected AuthError.invalidCredentials to be thrown")
        } catch let error as AuthError {
            XCTAssertEqual(error, .invalidCredentials)
        }
    }
}

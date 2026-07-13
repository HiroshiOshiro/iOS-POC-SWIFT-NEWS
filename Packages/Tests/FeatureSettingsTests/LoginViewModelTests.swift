import XCTest
import Dependencies
import CoreModel
import CoreRepository
import CoreTesting
@testable import FeatureSettings

@MainActor
final class LoginViewModelTests: XCTestCase {
    func testLoginSuccessSavesCurrentUser() async throws {
        let authRepository = FakeAuthRepository()
        authRepository.result = .success(User(id: "1", name: "Taro Yamada", email: "taro@example.com"))
        let userDataRepository = FakeUserDataRepository()
        let viewModel = withDependencies {
            $0.authRepository = authRepository
            $0.userDataRepository = userDataRepository
        } operation: {
            LoginViewModel()
        }
        viewModel.email = "taro@example.com"
        viewModel.password = "password123"

        await viewModel.login()

        var iterator = userDataRepository.observeCurrentUser().makeAsyncIterator()
        let savedUser = await iterator.next()
        XCTAssertEqual(savedUser??.email, "taro@example.com")
        XCTAssertNil(viewModel.errorMessage)
    }

    func testLoginFailureSetsErrorMessage() async throws {
        let authRepository = FakeAuthRepository()
        authRepository.result = .failure(AuthError.invalidCredentials)
        let viewModel = withDependencies {
            $0.authRepository = authRepository
            $0.userDataRepository = FakeUserDataRepository()
        } operation: {
            LoginViewModel()
        }
        viewModel.email = "wrong@example.com"
        viewModel.password = "short"

        await viewModel.login()

        XCTAssertNotNil(viewModel.errorMessage)
    }
}

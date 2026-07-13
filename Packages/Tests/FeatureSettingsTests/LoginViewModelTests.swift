import XCTest
import Factory
import CoreModel
import CoreRepository
import CoreTesting
@testable import FeatureSettings

@MainActor
final class LoginViewModelTests: XCTestCase {
    override func tearDown() {
        Container.shared.reset()
        super.tearDown()
    }

    func testLoginSuccessSavesCurrentUser() async throws {
        let authRepository = FakeAuthRepository()
        authRepository.result = .success(User(id: "1", name: "Taro Yamada", email: "taro@example.com"))
        let userDataRepository = FakeUserDataRepository()
        Container.shared.authRepository.register { authRepository }
        Container.shared.userDataRepository.register { userDataRepository }

        let viewModel = LoginViewModel()
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
        Container.shared.authRepository.register { authRepository }
        Container.shared.userDataRepository.register { FakeUserDataRepository() }

        let viewModel = LoginViewModel()
        viewModel.email = "wrong@example.com"
        viewModel.password = "short"

        await viewModel.login()

        XCTAssertNotNil(viewModel.errorMessage)
    }
}

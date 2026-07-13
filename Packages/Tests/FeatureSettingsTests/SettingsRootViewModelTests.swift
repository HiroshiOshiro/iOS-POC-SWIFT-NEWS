import XCTest
import Factory
import CoreModel
import CoreTesting
@testable import FeatureSettings

@MainActor
final class SettingsRootViewModelTests: XCTestCase {
    override func tearDown() {
        Container.shared.reset()
        super.tearDown()
    }

    func testObservesInitialLoggedInUser() async throws {
        let user = User(id: "1", name: "Taro Yamada", email: "taro@example.com")
        let userDataRepository = FakeUserDataRepository(initialUser: user)
        Container.shared.userDataRepository.register { userDataRepository }

        let viewModel = SettingsRootViewModel()
        try await Task.sleep(nanoseconds: 50_000_000)

        XCTAssertEqual(viewModel.currentUser, user)
    }

    func testLogoutClearsCurrentUser() async throws {
        let user = User(id: "1", name: "Taro Yamada", email: "taro@example.com")
        let userDataRepository = FakeUserDataRepository(initialUser: user)
        Container.shared.userDataRepository.register { userDataRepository }

        let viewModel = SettingsRootViewModel()
        try await Task.sleep(nanoseconds: 50_000_000)

        viewModel.logout()
        try await Task.sleep(nanoseconds: 50_000_000)

        XCTAssertNil(viewModel.currentUser)
    }
}

import Foundation
import CoreModel
import CoreRepository

@MainActor
public final class SettingsRootViewModel: ObservableObject {
    @Published public private(set) var currentUser: User?

    private let userDataRepository: UserDataRepository
    private var observeTask: Task<Void, Never>?

    public init(userDataRepository: UserDataRepository) {
        self.userDataRepository = userDataRepository
        observeTask = Task { [weak self] in
            guard let self else { return }
            for await user in userDataRepository.observeCurrentUser() {
                self.currentUser = user
            }
        }
    }

    deinit {
        observeTask?.cancel()
    }

    public func logout() {
        userDataRepository.clearCurrentUser()
    }
}

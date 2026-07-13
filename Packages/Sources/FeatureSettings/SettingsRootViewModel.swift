import Foundation
import Factory
import CoreModel
import CoreRepository

@MainActor
public final class SettingsRootViewModel: ObservableObject {
    @Published public private(set) var currentUser: User?

    @Injected(\.userDataRepository) private var userDataRepository: UserDataRepository
    private var observeTask: Task<Void, Never>?

    public init() {
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

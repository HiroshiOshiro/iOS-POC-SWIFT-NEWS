import Foundation
import Dependencies
import CoreModel
import CoreRepository

@MainActor
public final class SettingsRootViewModel: ObservableObject {
    @Published public private(set) var currentUser: User?

    @Dependency(\.userDataRepository) private var userDataRepository
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

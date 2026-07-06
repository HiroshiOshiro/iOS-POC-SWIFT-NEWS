import SwiftUI

@main
struct iOS_POC_SWIFT_NEWSApp: App {
    private let container = AppDIContainer()

    var body: some Scene {
        WindowGroup {
            RootTabView(container: container)
        }
    }
}

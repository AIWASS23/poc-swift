import SwiftUI
import SwiftData

@main
struct SwiftDataCoreDataApp: App {
    var body: some Scene {
        WindowGroup {
            AppTabBar()
                .modelContainer(for: UserSwiftData.self, isAutosaveEnabled: false)
        }
    }
}

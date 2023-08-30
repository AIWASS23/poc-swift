import SwiftUI

@main
struct UnitTestsPracticeApp: App {
    var body: some Scene {
        WindowGroup {
            UnitTestsView(isPremium: Bool.random())
        }
    }
}


import SwiftUI

@main
struct Cross_PlatformApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(InsectData())
        }
    }
}

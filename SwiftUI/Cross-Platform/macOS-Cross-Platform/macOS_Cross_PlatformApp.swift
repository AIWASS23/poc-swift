
import SwiftUI

@main
struct macOS_Cross_PlatformApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(InsectData())
        }
    }
}

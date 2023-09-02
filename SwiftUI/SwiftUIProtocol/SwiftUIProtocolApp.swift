import SwiftUI

@main
struct SwiftProtocolApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(colorTheme: AlternativeColorTheme(), dataSource: DefaultDataSource())
        }
    }
}

import SwiftUI

@main
struct DependencyInjectionApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(dataService: ProductionDataService())
        }
    }
}

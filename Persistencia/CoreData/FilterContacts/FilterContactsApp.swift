import SwiftUI

@main
struct FilterContactsApp: App {
    let persistenceController = PersistenceController.shared
    let coreDataStack = CoreDataStack(modelName: "ContactModel")
    
    @Environment(\.scenePhase) var scenePhases

    var body: some Scene {
        WindowGroup {
            ContentView(coreDataStack: coreDataStack)
                .environment(\.managedObjectContext, coreDataStack.managedObjectContext)
            
                .onChange(of: scenePhases) { _ in
                    coreDataStack.save()
                }
        }
    }
}

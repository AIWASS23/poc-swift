import SwiftUI

@main
struct FetchContactApp: App {
    let persistenceController = PersistenceController.shared
    private let coreDataStack = CoreDataStack(modelName: "ContactsModel")
    @Environment (\.scenePhase) var scenePhases
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, coreDataStack.managedObjectContext)
                .onChange(of: scenePhases) { _ in
                    coreDataStack.save()
                }
                .onAppear {
                    coreDataStack.addContacts(to: coreDataStack)
                }
        }
    }
}

import SwiftUI

@main
struct DeleteContactsApp: App {
    private let coreDataStack = CoreDataStack(modelName: "ContactsModel")
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext,
                              coreDataStack.managedObjectContext)
                .onAppear {
                    addContacts(to: coreDataStack)
                }
        }
        .onChange(of: scenePhase) { _ in
            coreDataStack.save()
        }
    }
}

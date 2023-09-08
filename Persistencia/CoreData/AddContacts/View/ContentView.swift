import SwiftUI
import CoreData

struct ContentView: View {

    @FetchRequest(sortDescriptors: [
        NSSortDescriptor(keyPath: \Contact.lastName, ascending: true),
        NSSortDescriptor(keyPath: \Contact.firstName, ascending: true)
        ]
    )
    var contacts: FetchedResults<Contact>
    @State var isAddContactPresented:Bool = true
    var coreDataStack: CoreDataStack

    var body: some View {

        NavigationView {
            List(contacts){
                ContactView(contact: $0)
            }
            .listStyle(.plain)
            .navigationBarTitle("Contacts", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                isAddContactPresented.toggle()
            }, label: {
                Image(systemName: "plus")
                    .font(.headline)
            }))
            .sheet(isPresented: $isAddContactPresented) {
                AddNewContact(isAddContactPresented: $isAddContactPresented)
                    .environmentObject(coreDataStack)
            }
        }
    }
}




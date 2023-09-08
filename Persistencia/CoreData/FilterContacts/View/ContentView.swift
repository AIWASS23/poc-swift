import SwiftUI
import CoreData

struct ContentView: View {
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Contact.lastName, ascending: true),
                          NSSortDescriptor(keyPath: \Contact.firstName, ascending: true)])
    var contacts: FetchedResults<Contact>
    var coreDataStack:CoreDataStack
    @State var isContactPresented:Bool = true
    @State private var searhText:String = ""
    
    
    var body: some View{
        NavigationView {
            FilteredContacts(filter: searhText)
            .navigationBarTitle("Contacts", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                isContactPresented.toggle()
            }, label: {
                Image(systemName: "plus")
                    .font(.headline)
            }))
            .sheet(isPresented: $isContactPresented) {
                AddNewContact(isContactPresented: $isContactPresented)
                    .environmentObject(coreDataStack)
            }
        }
        .searchable(text: $searhText)
    }
}

    

   

import SwiftUI
import CoreData

struct ContentView: View {
 
    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Contact.lastName, ascending: true),
            NSSortDescriptor(keyPath: \Contact.firstName, ascending: true)])
    var contacts:FetchedResults<Contact>

    var body: some View {
        List(contacts,id: \.self){
            ContactView(contact: $0)
        }
        .listStyle(.plain)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

import SwiftUI

struct FilteredContacts: View {
    let fetchRequest:FetchRequest<Contact>
    
    init(filter:String){
        let predicate:NSPredicate? = filter.isEmpty ? nil : NSPredicate(format: "lastName BEGINSWITH %@", filter)
        fetchRequest = FetchRequest<Contact>(sortDescriptors: [NSSortDescriptor(keyPath: \Contact.lastName, ascending: true),
            NSSortDescriptor(keyPath: \Contact.firstName, ascending: true)],predicate: predicate)
    }
    var body: some View {
        List(fetchRequest.wrappedValue,id: \.self){
            ContactView(contact: $0)
        }
        .listStyle(.plain)
    }
}


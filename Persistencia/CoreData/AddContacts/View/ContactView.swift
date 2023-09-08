import SwiftUI
import CoreData

struct ContactView: View {
    let contact:Contact
    var body: some View {
        HStack{
            Text(contact.firstName ?? "-")
            Text(contact.lastName ?? "-")
            Spacer()
            Text(contact.phoneNumber ?? "-")
        }
    }
}

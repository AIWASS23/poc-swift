import SwiftUI

struct ContactView: View {
    let contact:Contact
    var body: some View {
        HStack{
            Text(contact.firstName ?? "-")
            Text(contact.lastName ?? "-")
            Spacer()
            Text(contact.phoneNumber ??  "-")
        }
    }
}

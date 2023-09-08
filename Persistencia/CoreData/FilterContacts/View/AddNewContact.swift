import SwiftUI

struct AddNewContact: View {
    @Binding var isContactPresented:Bool
    @State var firstName:String = ""
    @State var lastName:String = ""
    @State var phoneNumber:String = ""
    @EnvironmentObject var coreDataStack:CoreDataStack
    private var isDisabled:Bool{
        firstName.isEmpty || lastName.isEmpty || phoneNumber.isEmpty
    }
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                TextField("First Name", text: $firstName)
                TextField("Last Name", text: $lastName)
                TextField("Phone Number", text: $phoneNumber)
                    .keyboardType(.phonePad)
                Spacer()
            }
            .padding(16)
            .navigationTitle("Add New Contact")
            .navigationBarItems(trailing: Button(action: saveContact){
                Image(systemName: "checkmark")
                    .font(.headline)
            }
            .disabled(isDisabled))
        }
    }
    
    func saveContact(){
        coreDataStack.insertContact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
        isContactPresented.toggle()
    }
}



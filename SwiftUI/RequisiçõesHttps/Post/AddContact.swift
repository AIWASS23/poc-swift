import Foundation
import SwiftUI
import Combine

struct AddContact: View {
    @State var id = 999
    
    @State var first_name: String = ""
    @State var last_name: String = ""
    @State var phone_number: String = ""
    @State var address: String = ""
    
    @State var birthday = Date()
    @State var birthdayString: String = ""
    @State var create_date = Date()
    @State var create_dateString: String = ""
    @State var updated_date = Date()
    @State var updated_dateString: String = ""
    
    @State var manager = DataPost()
    
    var body: some View {
        if manager.formCompleted {
            Text("Done").font(.headline)
        }
        VStack {
            NavigationView {
                Form {
                    Section() {
                        TextField("First Name", text: $first_name)
                        TextField("Last Name", text: $last_name)
                    }
                    Section() {
                        TextField("Phone Number", text: $phone_number)
                        TextField("Address", text: $address)
                    }
                    Section() {
                        DatePicker("Birthday", selection: $birthday, displayedComponents: .date)
                    }
                    Section() {
                        Button(action: {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateStyle = .short
                            
                            birthdayString = dateFormatter.string(from: birthday)
                            create_dateString = dateFormatter.string(from: create_date)
                            updated_dateString = dateFormatter.string(from: updated_date)
                            
                            print("Clicked")
                            
                            self.manager.checkDetails(id: self.id, first_name: self.first_name, last_name: self.last_name, phone_number: self.phone_number, address: self.address, birthday: self.birthdayString, create_date: self.create_dateString, updated_date: self.updated_dateString)
                            
                        }, label: {
                            Text("Add Contact")
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                        })
                    }.disabled(first_name.isEmpty || last_name.isEmpty || phone_number.isEmpty || address.isEmpty)
                }
            }.navigationTitle("New Contact")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

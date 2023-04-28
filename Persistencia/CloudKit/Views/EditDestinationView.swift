import SwiftUI

struct EditDestinationView: View {
    let destination: Destination
    private var stack = CoreDataStack.shared
    private var hasInvalidData: Bool {
        return 
            destination.caption.isBlank || destination.details.isBlank || (destination.caption == captionText && destination.details == detailsText)
    }

    @State private var captionText: String = ""
    @State private var detailsText: String = ""
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext

    init(destination: Destination) {
        self.destination = destination
    }

    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading) {
                    Text("Caption")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    TextField(text: $captionText) {}
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.bottom, 8)

                VStack(alignment: .leading) {
                    Text("Details")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    TextEditor(text: $detailsText)
                }
            }
            .padding()
            .navigationTitle("Edit Destination")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        managedObjectContext.performAndWait {
                            destination.caption = captionText
                            destination.details = detailsText
                            stack.save()
                            presentationMode.wrappedValue.dismiss()
                        }
                    } label: {
                        Text("Save")
                    }
                    .disabled(hasInvalidData)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
        }
        .onAppear {
            captionText = destination.caption
            detailsText = destination.details
        }
    }
}

// MARK: String
extension String {
    var isBlank: Bool {
        self.trimmingCharacters(in: .whitespaces).isEmpty
    }
}

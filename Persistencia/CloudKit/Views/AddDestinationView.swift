import SwiftUI

struct AddDestinationView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var caption: String = ""
    @State private var details: String = ""
    @State private var inputImage: UIImage?
    @State private var image: Image?
    @State private var showingImagePicker = false
    private var stack = CoreDataStack.shared

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Caption", text: $caption)
                } footer: {
                    Text("Caption is required")
                        .font(.caption)
                        .foregroundColor(caption.isBlank ? .red : .clear)
                }

                Section {
                    TextEditor(text: $details)
                } header: {
                    Text("Description")
                } footer: {
                    Text("Description is required")
                        .font(.caption)
                        .foregroundColor(details.isBlank ? .red : .clear)
                }

                Section {
                    if image == nil {
                        Button {
                            self.showingImagePicker = true
                        } label: {
                            Text("Add a photo")
                        }
                    }       

                    image?
                        .resizable()
                        .scaledToFit()
                } footer: {
                    Text("Photo is required")
                        .font(.caption)
                        .foregroundColor(image == nil ? .red : .clear)
                }   

                Section {
                    Button {
                        createNewDestination()
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Save")
                    }
                    .disabled(caption.isBlank || details.isBlank || image == nil)
                }
            }
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) { ImagePicker(image: $inputImage) }
            .navigationTitle("Add Destination")
        }
    }
}


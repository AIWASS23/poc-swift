import SwiftUI

struct ContentView: View {
    @State private var showScreen:Bool = false
    @State private var showPicker:Bool = false
    @State private var pickedImage: UIImage? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            Text(pickedImage == nil ? "Select Your Image!" : "SelectedImage")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.pink.opacity(0.5))
            
            if let pickedImage = pickedImage{
                Image(uiImage: pickedImage)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 300)
                    .cornerRadius(10)
                    .shadow(radius: 10)
            }
            
            Button {
                showScreen.toggle()
            } label: {
                Text("Open Screen")
            }
            .withCustomButtonStyle()
            .sheet(isPresented: $showScreen) {
                BasicUIViewControllerRepresentable(labelText: "Hello There..!")
            }
            
            Button {
                showPicker.toggle()
            } label: {
                Text("Open Picker")
            }
            .withCustomButtonStyle()
            .sheet(isPresented: $showPicker){
                UIImagePickerControllerRepresentable(image: $pickedImage, showScreen: $showPicker)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

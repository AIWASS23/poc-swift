import SwiftUI

struct Base64Image: View {
    let base64Image = base64
    
    var body: some View {
        if let data = Data(base64Encoded: base64Image ,options: .ignoreUnknownCharacters){
            let image = UIImage(data: data)
            Image(uiImage: image ?? UIImage())
                .resizable()
                .ignoresSafeArea()
                .aspectRatio(contentMode: .fill)
        }else{
            Text("Invalid Image")
        }
    }
}

//#Preview {
//    ContentView()
//}
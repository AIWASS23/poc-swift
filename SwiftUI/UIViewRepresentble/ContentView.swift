import SwiftUI

struct ContentView: View {
    @State private var text: String = ""
    @State private var placeHolder:String = "Type Here..."
    var body: some View {
        VStack {
            Text(text)
                .font(.largeTitle)
                .fontWeight(.bold)
            HStack{
                Text("SwiftUI:- ")
                    .font(.headline)
                    .fontWeight(.bold)
                TextField(placeHolder, text: $text)
                    .withCustomTextFieldModifier()
            }
            
            HStack{
                Text("UIKit:- ")
                    .font(.headline)
                    .fontWeight(.bold)
                UITextFieldViewRepresentable(text: $text, placeHolder: placeHolder, placeHolderColor: .red.withAlphaComponent(0.5))
                    .withCustomTextFieldModifier()
            }
        }
        .padding()
    }
}



struct UITextFieldViewRepresentable: UIViewRepresentable {
    
    @Binding var text:String
    var placeHolder:String
    let placeHolderColor:UIColor
    
    init(text: Binding<String>, placeHolder: String, placeHolderColor: UIColor) {
        self._text = text
        self.placeHolder = placeHolder
        self.placeHolderColor = placeHolderColor
    }
    
    func makeUIView(context: Context) -> UITextField {
        let textField = getTextField()
        textField.delegate = context.coordinator
        return textField
    }
    
    //From SwiftUI To UIKit
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
    
    
    //From UIKit to SwiftUI
    func makeCoordinator() -> Coordinator{
        return Coordinator(text: $text)
    }
    
    private func getTextField() -> UITextField {
        let textField = UITextField(frame: .zero)
        let placeHolder = NSAttributedString(string: placeHolder,attributes: [.foregroundColor : placeHolderColor])
        textField.attributedPlaceholder = placeHolder
        return textField
    }
    
    
    class Coordinator: NSObject, UITextFieldDelegate {
        
        @Binding var text:String
        
        init(text: Binding<String>) {
            self._text = text
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
    }
}


struct TextFieldModifer: ViewModifier {
    func body(content: Content) -> some View {
        content
        .font(.headline)
        .fontWeight(.semibold)
        .frame(height: 55)
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .background(Color.gray.opacity(0.5))
        .cornerRadius(10)
        .shadow(radius: 8)
    }
}

extension View {
    
    func withCustomTextFieldModifier() -> some View{
        modifier(TextFieldModifer())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

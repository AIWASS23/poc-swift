public struct CharLimitTextEditor: View {
    
    @State private var maxChars: Int = 100
    @State private var inputText: String = "Learn iOS"
    
    public var body: some View {
        let text = Binding(
            get: { self.inputText },
            set: { self.inputText = String($0.prefix(maxChars))
            }
        )
        
        NavigationStack {
            VStack {
                Text("Number of chars : \(text.wrappedValue.count)")
                    .foregroundColor(text.wrappedValue.count == maxChars ? .red : .primary)
                TextEditor(text: text)
            }
            .navigationTitle("Dev")
            .padding()
        }
    }
}

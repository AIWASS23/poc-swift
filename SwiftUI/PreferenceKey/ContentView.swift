import SwiftUI

struct ContentView: View {
    @State private var navTitle: String = "Hello Boss!"
    var body: some View {
        NavigationView {
            VStack{
                secondScreen(text: navTitle)
                    .navigationTitle("First navigate")
            }
        }
        .onPreferenceChange(customPrefrenceKey.self) { value in
            navTitle = value
        }
    }
}

struct secondScreen: View{
    
    let text: String
    @State private var newValue: String = ""
    var body: some View{
        Text(text)
            .onAppear(perform: getNewValue)
            .withCustomPreference(text: newValue)
        
    }
    
    func getNewValue(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            newValue = "New Value"
        }
    }
}

struct customPrefrenceKey: PreferenceKey{
    static var defaultValue: String = ""
    static func reduce(value: inout String, nextValue: () -> String) {
        value = nextValue()
    }
    
}

extension View{
    func withCustomPreference(text:String) -> some View{
        self
            .preference(key: customPrefrenceKey.self, value: text)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

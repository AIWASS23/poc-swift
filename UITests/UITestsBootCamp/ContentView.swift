import SwiftUI

class UITestsViewModel: ObservableObject{
    
    let placeHolder:String = "Add your name..."
    @Published var textFieldText:String = ""
    @Published var currentUserSignedIn:Bool
    
    init(currentUserSignedIn:Bool){
        self.currentUserSignedIn = currentUserSignedIn
    }
    
    func signUpBtnTapped(){
        guard !textFieldText.isEmpty else {return}
        currentUserSignedIn = true
    }
    
}

struct ContentView: View {
    
    @StateObject private var viewModel:UITestsViewModel
    
    init(currentUserSignedIn:Bool){
        _viewModel = StateObject(wrappedValue: UITestsViewModel(currentUserSignedIn: currentUserSignedIn))
    }
   
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color.pink,Color.black], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            ZStack{
                if viewModel.currentUserSignedIn{
                    SignedInView()
                        .frame(maxWidth: .infinity,maxHeight: .infinity)
                        .transition(.move(edge: .trailing))
                }
                
                if !viewModel.currentUserSignedIn{
                    signUpLayer
                        .frame(maxWidth: .infinity,maxHeight: .infinity)
                        .transition(.move(edge: .leading))
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(currentUserSignedIn: true)
    }
}


extension ContentView{
    private var signUpLayer: some View{
        VStack{
            TextField(viewModel.placeHolder, text: $viewModel.textFieldText)
                .font(.headline)
                .padding()
                .background(.white)
                .cornerRadius(10)
                .accessibilityIdentifier("SignUpTextField")
            
            Button {
                withAnimation(.spring()){
                    viewModel.signUpBtnTapped()
                }
            } label: {
                Text("SignUp")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.pink)
                    .cornerRadius(10)
            }
            .accessibilityIdentifier("SignUpButton")

        }
        .padding()
    }
}


struct SignedInView: View{
    @State private var showAlert:Bool = false
    var body: some View{
        NavigationView {
            VStack(spacing: 10) {
                Button {
                    showAlert.toggle()
                } label: {
                    Text("Show Welcome Alert")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.gradient)
                        .cornerRadius(10)
                }
                .accessibilityIdentifier("ShowAlertButton")
                .alert("Welcome to the App!", isPresented: $showAlert){}
                
                NavigationLink {
                    Text("Destination")
                } label: {
                    Text("Navigate")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green.gradient)
                        .cornerRadius(10)
                }
                .accessibilityIdentifier("navigationLinkToDestination")

            }
            .padding()
            .navigationTitle("Welcome!")
        }
    }
}

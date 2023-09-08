import SwiftUI

struct DoCatchTryThrowView: View {
    @StateObject private var viewModel:DoCatchTryThrowViewModel
    
    init(manager:DoCatchTryThrowProtocol) {
        _viewModel = StateObject(wrappedValue: DoCatchTryThrowViewModel(manager: manager))
        //Dependency Injection
    }
    
    var body: some View {
        NavigationView{
            VStack(spacing: 30){
                textView
                toggleButton
            }
            .padding(.horizontal,10)
            .padding(.vertical,100)
            .navigationTitle("DoCatchTryThrow")
        }
    }
}


extension DoCatchTryThrowView{
    
    private var textView: some View{
        Text(viewModel.text)
            .font(.headline)
            .foregroundColor(.white)
            .fontWeight(.bold)
            .withDoCatchTryThrowModifier()
            .onTapGesture {
                viewModel.getTitle4()
            }
    }
    
    private var toggleButton: some View{
        Button {
            viewModel.manager.isActive.toggle()
            viewModel.text = "Default Text"
        } label: {
            Text("Toggle: \(viewModel.manager.isActive.description)")
                .font(.headline)
                .foregroundColor(.white)
                .fontWeight(.bold)
                .withDoCatchTryThrowModifier(backgroundColor: .green.opacity(0.6))
        }
    }
}



struct DoCatchTryThrowModifier:ViewModifier{
    
    let backgroundColor:Color
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            .background(backgroundColor)
            .cornerRadius(10)
    }
}


extension View{
    
    func withDoCatchTryThrowModifier(backgroundColor:Color = Color.red.opacity(0.6)) -> some View{
        modifier(DoCatchTryThrowModifier(backgroundColor: backgroundColor))
    }
}

struct DoCatchTryThrowView_Previews: PreviewProvider {
    static var previews: some View {
        DoCatchTryThrowView(manager: DoCatchTryThrowDataManager())
    }
}

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AdvancedCombineViewModel()
    var body: some View {
        ScrollView{
            HStack {
                VStack{
                    ForEach(viewModel.data,id: \.self){
                        Text($0)
                            .font(.largeTitle)
                            .fontWeight(.black)
                    }
                    
                    if !viewModel.error.isEmpty{
                        Text(viewModel.error)
                    }
                }
                VStack{
                    ForEach(viewModel.dataBools,id: \.self){
                        Text($0.description)
                            .font(.largeTitle)
                            .fontWeight(.black)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

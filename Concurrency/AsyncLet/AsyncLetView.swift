import SwiftUI

struct AsyncLetView: View {
    @StateObject private var viewModel = AsyncLetViewModel()
    let column = [GridItem(.flexible()),GridItem(.flexible())]
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: column) {
                    ForEach(viewModel.images,id: \.self){ image in
                       Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .shadow(radius: 10)
                    }
                }
            }
            .navigationTitle(viewModel.title)
        }
        .onAppear{
            // 1
            //viewModel.fetImageSingleTask()
            
            
            // 2
            //viewModel.fetImageMultipleTask()
            
            // 3
            //viewModel.fetImagesAsyncLet()
            
            // 4
            DispatchQueue.main.asyncAfter(deadline: .now() + 5){
                viewModel.fetImagesAsyncLet2()
            }
        }
        
    }
}

struct AsyncLetView_Previews: PreviewProvider {
    static var previews: some View {
        AsyncLetView()
    }
}

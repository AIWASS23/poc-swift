import SwiftUI

struct TaskGroupView: View {
    @StateObject private var viewModel:TaskGroupViewModel
    init(manager:TaskGroupDataProtocol,urlString:String){
        _viewModel = StateObject(wrappedValue: TaskGroupViewModel(manager: manager, urlString: urlString))
    }
    let coloumns = [GridItem(.flexible()),GridItem(.flexible())]
    var body: some View {
        NavigationView {
            ScrollView{
                LazyVGrid(columns: coloumns) {
                    ForEach(viewModel.images,id: \.self){ image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .shadow(radius: 10)
                    }
                }
            }
            .navigationTitle("Task Group 😍")
        }
        .task {
            // 1
            //await viewModel.fetchImage()
            
            // 2
            //await viewModel.fetImagesWithAyncLet()
            
            // 3
           // await viewModel.fetImageWithTaskGroup()
            
            // 4
            //await viewModel.fetImageWithTaskGroupNumber(number: 5)
            
            // 5
            await viewModel.fetchImagesWithTaskGroupWithNumberWithOptional(number: 8)            
        }
    }
}

struct TaskGroupView_Previews: PreviewProvider {
    static var previews: some View {
        TaskGroupView(manager: TaskGroupDataManager(), urlString: "https://picsum.photos/200")
    }
}

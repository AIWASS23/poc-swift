import SwiftUI

struct CheckedContinuationView: View {
    @StateObject private var viewModel: CheckedContinuationViewModel
    
    init(dataService: CheckedContinuationProtocol, urlString: String) {
        _viewModel = StateObject(wrappedValue: CheckedContinuationViewModel(dataService: dataService, urlString: urlString))
    }
    
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .task {
            
            // 1
            //await viewModel.fetchImage()
            
            // 2
            //await viewModel.fetchImage2()
            
            //3
            await viewModel.fetchImageFromDatabase()
        }
    }
}

struct CheckedContinuationView_Preview: PreviewProvider{
    static var previews: some View{
        CheckedContinuationView(dataService: CheckedContinuationDataServices(), urlString: "https://picsum.photos/200")
    }
}

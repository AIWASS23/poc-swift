import Foundation
import SwiftUI

struct DownloadImageAsyncView: View{
    
    @StateObject private var viewModel = DownloadImageAsyncViewModel()
    
    var body: some View{
        ZStack{
            Color.black.ignoresSafeArea()
            if let image = viewModel.image{
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 250,height: 250)
                    .cornerRadius(20)
                    .onTapGesture {
                        viewModel.fetImagesWithTask()
                    }
            }
        }
        .onAppear{
            // 1
            //viewModel.fetchImagesWithComplpetionClousure()
            
            // 2
            //viewModel.fetImagesWithCombine()
            
            // 3
            //viewModel.fetImagesWithCombine2()
            
            // 4
            viewModel.fetImagesWithTask()
        }
    }
}

import Foundation
import SwiftUI

struct AsyncAwaitView: View{
    
    @StateObject private var viewModel = AsyncAwaitViewModel()
    var body: some View{
        List{
            ForEach(viewModel.dataArray, id: \.self) { data in
                Text(data)
            }
        }
        .onAppear{
            // 1
            //viewModel.addTitle1()
            
            // 2
            //viewModel.addTitle2()
            
            // 3
            Task{
                await viewModel.addAuthor1()
                
                await viewModel.addSomeThing()
                let finalText = "FinalText: \(Thread.current)"
                viewModel.dataArray.append(finalText)
                
            }
        }
    }
}

struct AsyncAwaitView_Preview: PreviewProvider{
    static var previews: some View {
        AsyncAwaitView()
    }
}

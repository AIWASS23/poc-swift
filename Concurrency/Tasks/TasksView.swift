//
//  TasksView.swift
//  SwiftConcurrency
//
//  Created by Ganesh on 30/08/23.
//

import SwiftUI

struct TaskHomeView:View{
    var body: some View{
        NavigationView {
            ZStack{
                NavigationLink {
                    TasksView()
                } label: {
                    Text("Click Me! 🔗")
                }
            }
            .navigationTitle("Home")
        }
    }
}

struct TasksView: View {
    
    @StateObject private var viewModel = TasksViewModel()
    @State private var fetImage:Task<(),Never>? = nil
    @State private var count:Int = 0
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    
    var body: some View {
        VStack(spacing: 30){
            
            Text("TIMER COUNT: \(count)")
                .font(.headline)
                .fontWeight(.bold)
            
            if let image = viewModel.image{
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 250,height: 250)
            }
            
            if let image = viewModel.image2{
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 250,height: 250)
            }
        }
        
        .onReceive(timer, perform: { _ in
            count = count + 1 <= 5 ? count + 1 : count
        })
        
        .onAppear{
            //viewModel.printTaskPriority()
            //viewModel.printTaskPriority2()
            viewModel.printParentChildTask()
            viewModel.resetImage()
            count = 0
            //taskFetchImages()
            //taskFetchImages2()
        }
        
        .task {
            try? await Task.sleep(nanoseconds: 5_000_000_000)
            await viewModel.fetImage()
            await viewModel.fetImage2()
           
        }
        
        .onDisappear{
            fetImage?.cancel()
        }
    }
}

extension TasksView{
    
    func taskFetchImages(){
        Task{
            try? await Task.sleep(nanoseconds:5_000_000_000)
            await viewModel.fetImage()
            await viewModel.fetImage2()
        }
    }
    
    func taskFetchImages2(){
        fetImage = Task{
            try? await Task.sleep(nanoseconds: 5_000_000_000)
            await viewModel.fetImage()
        }
    }
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TaskHomeView()
    }
}

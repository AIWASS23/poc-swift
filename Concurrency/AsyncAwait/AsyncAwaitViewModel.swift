import Foundation
import SwiftUI

class AsyncAwaitViewModel: ObservableObject{

    @Published var dataArray:[String] = []

    func addTitle1(){
        // Main Thread
        let title1 = "Title1: \(Thread.current)\n isMain?: \(Thread.isMainThread)"
        dataArray.append(title1)
    }

    func addTitle2(){
        DispatchQueue.global().asyncAfter(deadline: .now() + 2){

            // Background Thread
            let title2 = "Title2: \(Thread.current)\n isMain?: \(Thread.isMainThread)"

            // Switching to Main Thread
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}

                // Main Thread
                self.dataArray.append(title2)
                let title3 = "Title3: \(Thread.current)\n isMain?: \(Thread.isMainThread)"
                self.dataArray.append(title3)
            }
        }
    }

    func addAuthor1() async{

        // BackGround Thread
        let author1 = "Author1: \(Thread.current)"
        self.dataArray.append(author1)


        // sleep for 2 secs
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        let author2 = "Author2: \(Thread.current)"


        // Switching Back To Main Thread
        await MainActor.run{
            self.dataArray.append(author2)

            let author3 = "Author3: \(Thread.current)"
            self.dataArray.append(author3)
        }
        
        await addSomeThing()
    }

    func doSomething() async throws{
        print("do Something")
    }

    func addSomeThing() async{

        // BackGround Thread
        let someThing1 = "Something1: \(Thread.current)"
        self.dataArray.append(someThing1)


        // sleep for 2 secs
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        let someThing2 = "Something2: \(Thread.current)"

        // Switching Back To Main Thread
        await MainActor.run{
            self.dataArray.append(someThing2)

            let someThing3 = "Something3: \(Thread.current)"
            self.dataArray.append(someThing3)
        }
    }
}


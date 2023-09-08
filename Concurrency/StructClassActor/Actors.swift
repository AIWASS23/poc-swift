import Foundation
import SwiftUI

actor CustomActor {
    var title:String
    init(title: String) {
        self.title = title
    }
    
    func updateTitle(_ title:String){
        self.title = title
    }
}

extension StructClassActor {
    func customActorTests() {
        Task{
            // Need to get async -> Call them inside 'Task' block
            print("customActorTests")
            let actor1 = CustomActor(title: "Title1")
            await print("Actor1: \(actor1.title)")
            // Actor1: Title1
            
            // actor1.title = "Title2" -> Ban
            // Actor-isolated property 'title' can not be mutated from a non-isolated context
            await actor1.updateTitle("Title2")
            await print("Actor2: \(actor1.title)")
            // Actor1 title : Actor2
            
            /*
             customActorTests
             Actor1: Title1
             Actor2: Title2
             */

        }
    }
}

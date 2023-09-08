import Foundation
import SwiftUI


//MARK: - ARC

class StrongClass1 {

    var title:String
    var strongClass2: StrongClass2?
    var weakClass: WeakClass?
    init(title: String, strongClass2: StrongClass2? = nil, weakClass: WeakClass? = nil) {
        self.title = title
        self.strongClass2 = strongClass2
        self.weakClass = weakClass
        print("\(title) is initialized")
    }
    
    deinit{
        print("\(title) is deinitialized")
    }
    
}

class StrongClass2 {
    var title:String
    var strongClass1: StrongClass1?
    
    init(title: String, strongClass1: StrongClass1? = nil) {
        self.title = title
        self.strongClass1 = strongClass1
        print("\(title) is initialized")
    }
    
    deinit{
        print("\(title) is deinitialized")
    }
    
}

class WeakClass {
    var title:String
    weak var strongClass1: StrongClass1?
    
    init(title: String, strongClass1: StrongClass1? = nil) {
        self.title = title
        self.strongClass1 = strongClass1
        print("\(title) in initialized")
    }
    
    deinit{
        print("\(title) is deinitialized")
    }
}

extension StructClassActor {
    func classTest4(){
        var class1: StrongClass1? = StrongClass1(title: "Strong Class1")
        var class2: StrongClass2? = StrongClass2(title: "Strong Class2")
        //Strong Class1 is initialized
        //Strong Class2 is initialized
        
        class1?.strongClass2 = class2
        class2?.strongClass1 = class1
        class1?.strongClass2 = nil
        class2?.strongClass1 = nil
        class1 = nil
        class2 = nil
        //Strong Class1 is deinitialized
        //Strong Class2 is deinitialized
        
        class1 = StrongClass1(title: "Strong Class1")
        class2 = StrongClass2(title: "Strong Class2")
        //Strong Class1 is initialized
        //Strong Class2 is initialized
        
        class1?.strongClass2 = class2
        class2?.strongClass1 = class1
        class1 = nil
        class2 = nil
        //Strong Class1 is initialized
        //Strong Class2 is initialized
        // Still Strong reference cycle retained -> Memory leaking
    }
    
     func classTest5() {
        var class1:StrongClass1? = StrongClass1(title: "Strong Class1")
        var class2:WeakClass? = WeakClass(title: "Weak Class")
        //Strong Class1 is initialized
        //Weak Class in initialized
        class1?.weakClass = class2
        class2?.strongClass1 = class1
        class1 = nil
        class2 = nil
        // Strong Class1 is deinitiated
        // Weak Class is deinitiated
        // strongClass1 inside class2(Weak Class instance) -> nil, then ARC -> 0, then class1 -> deinit
        // weak reference -> make its non-having strong reference less than strong reference
        
    }
}

import Foundation

// Class
class CustomClass {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func updateTitle(_ title:String){
        self.title = title
    }
    // Does not have to set "mutating" keyward inside Class
}

extension StructClassActor{
    func customClassTest1(){
        print("customClassTest1")
        let objectA = CustomClass(title: "Starting Tile!")
        print("objectA: \(objectA.title)")
        print("Pass the REFERENCE of objectA to objectB")
        let objectB = objectA
        print("objectB: \(objectB.title)")
        // objectA: Starting Tile!
        // objectB: Starting Tile!
        objectB.title = "Second Title"
        // let title -> var title. complier changes it: not 'let' objectB. (let objectB remains same)
        print("objectB: Title Changed!")
        print("objectA: \(objectA.title)")
        print("objectB: \(objectB.title)")
        // objectA: Second Title!
        // ObjectB : Second Title -> ObjectA === ObjectB referencing same place (: Reference Type)
        print(objectA === objectB)
        // true (=== operator to check the reference)
        
        /*
         customClassTest1
         objectA: Starting Tile!
         Pass the REFERENCE of objectA to objectB
         objectB: Starting Tile!
         objectB: Title Changed!
         objectA: Second Title
         objectB: Second Title
         true
         */
    }
    
    func customClassTest2() {
        print("customClassTest2")
        let class1 = CustomClass(title: "Title1")
        print("Class1: \(class1.title)")
        class1.title = "Title2"
        print("Class2: \(class1.title)")
        //Class1: Title1
        //Class2: Title2
        
        let class2 = CustomClass(title: "Title1")
        print("Class2: \(class2.title)")
        class2.updateTitle("Title2")
        print("Class2: \(class2.title)")
        
    }
}


import Foundation
import SwiftUI

struct CustomStrut{
    var title:String
    // Default Initializer from Swift
}

struct CustomStruct2{
    var title:String
    
    func makeNewStruct(_ title:String) -> CustomStruct2{
        return CustomStruct2(title: title)
    }
    
    mutating func updateTitle(_ newTitle:String){
        self.title = newTitle
    }
}

struct CustomStruct3{
    private(set) var title:String
    // private(set) means set only property within the struct
    
    init(title: String) {
        self.title = title
    }
    
    func getTitle() -> String{
        return title
    }
    
    mutating func setTile(_ title: String){
        self.title = title
    }
}

extension StructClassActor{
    
    func customStructTest1(){
        print("customStructTest1")
        let objectA = CustomStrut(title: "Starting Tile!")
        print("objectA: \(objectA.title)")
        print("Pass the value of objectA to objectB")
        var objectB = objectA
        print("objectB: \(objectB.title)")
        // ObjectA : Starting Title
        // ObjectB : Starting Title
        objectB.title = "Second Title"
        // let title -> var title, let objectB -> var objectB. complier changes it
        print("objectB: Title Changed!")
        print("objectA: \(objectA.title)")
        print("objectB: \(objectB.title)")
        // objectA: Starting Tile!
        // ObjectB : Second Title -> ObjectA <-> ObjectB not referencing themselves. (: Value Type)
        
        /*
         customStructTest1
         objectA: Starting Tile!
         Pass the value of objectA to objectB
         objectB: Starting Tile!
         objectB: Title Changed!
         objectA: Starting Tile!
         objectB: Second Title
         */
    }
    
    func customStruct2Test(){
        print("customStruct2Test")
        var struct1 = CustomStrut(title: "Title1")
        print("Struct1: \(struct1.title)")
        struct1.title = "Title2"
        print("Struct1: \(struct1.title)")
        
        // Struct1: Title1
        // Struct1: Title2
        
        var struct2 = CustomStruct2(title: "Title1")
        print("Struct2: \(struct2.title)")
        struct2 = CustomStruct2(title: "Title2")
        // totally new struct assigned
        print("Struct2: \(struct2.title)")
        
        // Struct2: Title1
        // Struct2: Title2
        
        var struct3 = CustomStruct2(title: "Title1")
        print("Struct3: \(struct3.title)")
        struct3 = struct3.makeNewStruct("Title2")
        print("struct3: \(struct3.title)")
        // Totally new Structure
        //Struct3: Title1
        //struct3: Title2
        
        var struct4 = CustomStruct2(title: "Title1")
        print("Struct4: \(struct4.title)")
        struct4.updateTitle("Title2")
        print("Struct4: \(struct4.title)")
        //Struct4: Title1
        //Struct4: Title2
        
        /*
         customStruct2Test
         Struct1: Title1
         Struct1: Title2
         Struct2: Title1
         Struct2: Title2
         Struct3: Title1
         struct3: Title2
         Struct4: Title1
         Struct4: Title2
         */
        
    }
    
    func customStruct3Test(){
        var struct1 = CustomStruct3(title: "Title1")
        print("Struct1: \(struct1.getTitle())")
        struct1.setTile("Title2")
        print("struct1 \(struct1.getTitle())")
        
        // Struct1: Title1
        // Struct1 Title2
        
        // get, set method to handle data inside struct
    }
}



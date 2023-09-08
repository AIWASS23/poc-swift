/*
 
 VALUE TYPES:
 - Struct, Enum, String, Int etc.
 - Stored in Stack
 - Faster
 - Thread safe
 - When you assign or pass value type a new copy of data is created
 
 REFERENCE TYPES:
 - Class, Functions, Actors
 - Stored in Heap
 - Slower, but synchronized
 - Not Thread safe
 - When you assign or pass reference type a new reference to original instance will be created (pointer)
 
 - - - - - - - - - - - - - - - - - - - - - -
 
 STACK:
 - Stores Value Types
 - varibles allocated on the stack are stored directly to the memory, and access tot this memory is very fast
 - Each thread has it's own stack
 
 HEAP:
 - Stores Reference types
 - Shared across threads
 
 - - - - - - - - - - - - - - - - - - - - - -
 
 STRUCTS:
 - Based on VALUES
 - Can be mutated
 - Stored in the Stack
 
 CLASS:
 - Based on REFERENCE (INSTANCES)
 - Stored in Heap
 - Inherit from other classes
 
 ACTOR:
 - Based on REFERENCE (INSTANCES)
 - Stored in Heap
 - Thread safe
 
 - - - - - - - - - - - - - - - - - - - - - -
 when to use structs, classes, actors

 STRUCTS: Data Model, Views
 CLASS: ViewModels
 ACTOR: Shared "Managers" and "Data store"
 
 */

import SwiftUI

struct StructClassActor: View {
    var body: some View {
        Text("Hello World")
        .onAppear{
            runTest()
        }
    }
}

// Struct

extension StructClassActor{
    
    private func runTest(){
        print("Test Started")
//        customStructTest1()
//        printDivider()
//        customClassTest1()
//        customStruct2Test()
//        customStruct3Test()
//        printDivider()
//        customClassTest2()
//        printDivider()
//        customActorTests()
//        classTest4()
        classTest5()
    }
    
    private func printDivider(){
        print("""
    -------------------------------------------------
    """)
    }
}


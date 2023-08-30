import SwiftUI

@main
struct UITestsBootCampApp: App {
    
    var currentUserSignedIn:Bool = false
    
    init(){
        // First Initializer when app launched
        //let userSignedIn:Bool = CommandLine.arguments.contains("-UITest_StartSignedIn") ? true : false
        let userSignedIn:Bool = ProcessInfo.processInfo.arguments.contains("-UITest_StartSignedIn") ? true : false
        //let value = ProcessInfo.processInfo.environment["-UITest_StartSignedIn2"]
        //let userSignedIn: Bool = value == "true" ? true : false
        currentUserSignedIn = userSignedIn
    }
    var body: some Scene {
        WindowGroup {
            ContentView(currentUserSignedIn: currentUserSignedIn)
        }
    }
}

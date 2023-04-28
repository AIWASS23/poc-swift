import SwiftUI

@main
struct AppMain: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, CoreDataStack.shared.context)
        }
    }
}

/*
    A struct define a entrada principal (entry point) da aplicação e configura a primeira cena (scene) 
    da interface do usuário. Ele define um objeto AppMain que conforma ao protocolo App do SwiftUI e 
    define o método body que retorna uma única cena (WindowGroup) que contém a HomeView. Além disso, 
    ele usa o adaptador UIApplicationDelegateAdaptor para definir o AppDelegate da aplicação, que é um 
    objeto que gerencia o ciclo de vida da aplicação e configurações gerais. Por fim, ele define o 
    ambiente de gerenciamento de objetos do CoreData (managedObjectContext) para ser utilizado pela 
    HomeView.
*/
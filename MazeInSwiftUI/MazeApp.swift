import SwiftUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }.navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

/*
    Esse script cria a estrutura básica do aplicativo e define a tela inicial do aplicativo como uma 
    NavigationView que contém um único conteúdo ContentView. Ele também aplica o estilo de navegação 
    StackNavigationViewStyle() à NavigationView, que empilha as visualizações de navegação em vez de 
    usar um controlador de navegação tradicional.
*/

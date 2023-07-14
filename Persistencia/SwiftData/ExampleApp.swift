import SwiftUI
import SwiftData

@main
struct ExampleApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Person.self)
        //  O código usa o método modelContainer(for:) para criar um container de modelo de dados para a struct Person. O container de modelo de dados é usado para armazenar os dados persistentes da aplicação.


    }
}
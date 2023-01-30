import SwiftUI
import OrderedCollections
import Foundation

/*
    Este código cria uma exibição que exibe um gráfico de dados do pinguim. O gráfico é criado com a 
    visualização PenguinChart e os dados são carregados da classe PenguinsDataPoint. O carregamento dos 
    dados é feito de forma assíncrona em segundo plano para que não interfira na thread principal. 
    A variável de erro é definida se houver um erro durante o carregamento dos dados.
*/

struct ContentView: View {

    @State var data: [PenguinsDataPoint] = []
    @State var error: Error? = nil
    
    var body: some View {
        PenguinChart(
            dataset: self.data
        )
        .task(priority: .background) {
            do {
                self.data = try await PenguinsDataPoint.load()
            } catch {
                self.error = error
            }
        }
    }
}
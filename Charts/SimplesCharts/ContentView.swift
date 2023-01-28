import SwiftUI

/*
    A struct tem duas variáveis de estado, "data" e "error", ambas são inicializadas como vazias. A struct 
    também contém uma propriedade "body" que define a aparência da tela. A propriedade "body" usa um VStack 
    e verifica se há um erro (error) ou se os dados estão vazios (data.isEmpty). Se houver um erro, exibe 
    uma mensagem de erro com a descrição localizada do erro. Se os dados estiverem vazios, exibe um 
    ProgressView em forma de círculo. Se não houver erro e os dados não estiverem vazios, exibe um gráfico 
    chamado SimpleBabyChart com os dados. Existe também uma tarefa com prioridade de background, que tenta 
    carregar os dados da struct "BabyNamesDataPoint", usando um método "load" e caso dê algum erro, 
    armazena no variavel "error".
*/

struct ContentView: View {
    @State var data: [BabyNamesDataPoint] = []

    @State var error: Error? = nil

    var body: some View {
        VStack {
            if let error = error {
                Text("error: \(error.localizedDescription)")
            } else if data.isEmpty {
                ProgressView().progressViewStyle(.circular)
            } else {
                SimpleBabyChart(data: data)
            }
        }
        .task(priority: .background) {
            do {
                self.data = try await BabyNamesDataPoint.load()
            } catch {
                self.error = error
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
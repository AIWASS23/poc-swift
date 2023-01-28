import SwiftUI
import OrderedCollections

/*
    Esse código é uma estrutura chamada ContentView, que é uma exibição na estrutura SwiftUI. Ele tem duas 
    variáveis @State, data e error, ambas inicializadas com valores vazios. O corpo da exibição contém uma 
    instrução if-else que verifica a presença de um erro ou dados. Se houver um erro, ele exibe uma exibição 
    de texto com a descrição localizada do erro. Se não houver nenhum erro e nenhum dado, ele exibirá um 
    ProgressView com um rótulo de acessibilidade de "Downloading Data". Caso contrário, ele exibe uma 
    visualização RidgeBabyChart com acessibilidade definida como false.

    O código também inclui uma extensão em Array where Element == BabyNamesDataPoint que adiciona uma 
    propriedade computada chamada yearOfMaxProportion que retorna o ano com a maior proporção da matriz de 
    objetos BabyNamesDataPoint.

    Por fim, há uma task closure que tenta carregar objetos BabyNamesDataPoint e classificá-los em 
    um OrderedDictionary agrupado por nome. Se algum erro ocorrer durante esse processo, ele será armazenado 
    na variável self.error para uso posterior no corpo do ContentView.
*/

struct ContentView: View {

    @State var data: OrderedDictionary<String, [BabyNamesDataPoint]> = [:]
    @State var error: Error? = nil

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            if let error = error {
                Text("error: \(error.localizedDescription)")
            } else if data.isEmpty {
                ProgressView().progressViewStyle(.circular).accessibilityLabel("Downloading data")
            } else {
                RidgeBabyChart(groupedData: data).accessibilityHidden(false)
            }
        }
        .task(priority: .background) {
            do {

                let data = try await BabyNamesDataPoint.load()

                let groupedData = Dictionary(grouping: data) { item in
                    item.name
                }


                let sorted = groupedData.sorted { a, b in
                    a.value.yearOfMaxProportion < b.value.yearOfMaxProportion
                }

                self.data = OrderedDictionary(
                    uniqueKeysWithValues: sorted
                )

//                let sortedDictValues = dataDict.mapValues { babies in
//                    babies.sorted { a, b in
//                        a.year < b.year
//                    }
//                }


            } catch {
                self.error = error
            }
        }
    }
}

extension Array where Element == BabyNamesDataPoint {
    var yearOfMaxProportion: Date {
        guard let first = self.first else {
            fatalError("There must be at least one data point!!")
        }
        var year = first.year
        var proportion = first.proportion
        for element in self {
            if element.proportion > proportion {
                year = element.year
                proportion = element.proportion
            }
        }
        return year
    }
}

import Foundation
import TabularData

/*
    TabularData é uma biblioteca para Swift que fornece uma maneira fácil e flexível de trabalhar com dados 
    tabulares. Ele permite aos usuários carregar, manipular e analisar dados em formato CSV ou Excel, bem 
    como exportá-los de volta para esses formatos. Ele também oferece recursos para filtrar, agrupar, 
    ordenar e resumir dados. Além disso, ele fornece suporte para dados faltantes, tipos personalizados e 
    muito mais. TabularData é uma biblioteca útil para qualquer pessoa que trabalhe com dados tabulares em 
    sua aplicação swift.

    Esse script usa a biblioteca TabularData. Ele define uma struct chamada "BabyNamesDataPoint" que 
    representa um conjunto de dados de nomes de bebês. A struct contém várias propriedades, incluindo ano, 
    sexo, nome, contagem e proporção. A struct também possui uma função estática chamada "load" que é 
    marcada como "async" e "throws". A função "load" usa a classe URLSession para carregar dados a partir de 
    uma url específica, ela carrega um arquivo CSV e cria um objeto DataFrame a partir dos dados, 
    especificando as colunas e tipos de dados. Depois os dados são ordenados pela coluna "name", e retorna 
    uma matriz de objetos "BabyNamesDataPoint" criados a partir das informações do arquivo CSV.
    A struct tem também uma extensão, que adiciona conformidade com o protocolo "Identifiable" do swiftUI, 
    permitindo que os objetos "BabyNamesDataPoint" possam ser usados ​​com elementos SwiftUI que esperam dados 
    identificáveis.
*/

struct BabyNamesDataPoint {
    static let url = URL(string: "https://raw.githubusercontent.com/holtzy/data_to_viz/master/Example_dataset/5_OneCatSevNumOrdered.csv")!

    enum Sex: String {
        case male = "M"
        case female = "F"
    }

    let year: Date
    let sex: Sex
    let name: String
    let count: Int
    let proportion: Float


    static func load() async throws -> [Self] {
        let (data, _) = try await URLSession.shared.data(from: Self.url)

        var dataFrame = try DataFrame(
            csvData: data,
            columns: [
                "year",
                "sex",
                "name",
                "n",
                "prop"
            ],
            types: [
                "year": CSVType.integer,
                "sex": CSVType.string,
                "name": CSVType.string,
                "n": CSVType.integer,
                "prop": CSVType.float
            ],
            options: CSVReadingOptions(hasHeaderRow: true)
        )
        dataFrame.sort(on: "name")
        return dataFrame.rows.compactMap { row in
            guard
                let _year = row["year", Int.self],
                let year = Calendar.current.date(from: DateComponents(year: _year)),
                let name = row["name", String.self],
                let count = row["n", Int.self],
                let proportion = row["prop", Float.self],
                let sex_string = row["sex", String.self], let sex = Sex(rawValue: sex_string) else {
                return nil
            }

            return Self.init(year: year, sex: sex, name: name, count: count, proportion: proportion)
        }
    }
}


extension BabyNamesDataPoint: Identifiable {
    struct ObjectIdentifier: Hashable {
        let year: Date
        let name: String
    }
    var id: ObjectIdentifier {
        ObjectIdentifier(year: self.year, name: self.name)
    }
}


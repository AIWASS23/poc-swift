mport Foundation

struct Resort: Codable, Identifiable {
    let id: String
    let name: String
    let country: String
    let description: String
    let imageCredit: String
    let price: Int
    let size: Int
    let snowDepth: Int
    let elevation: Int
    let runs: Int
    let facilities: [String]

    var facilityTypes: [Facility] {
        facilities.map(Facility.init)

        /*
            Em Swift, os métodos map, compactMap e flatMap são todos usados para transformar e filtrar 
            valores em um array ou outro tipo de coleção. A diferença entre eles é a forma como eles lidam 
            com valores nulos (ou valores opcionais) e com a estrutura do array resultante:

            map: usado para transformar cada elemento em um array ou coleção em outro elemento. Ele não 
            remove valores nulos ou opcionais, eles serão incluídos no novo array como valores nulos.

            compactMap: similar ao map, mas remove valores nulos ou opcionais do novo array resultante. 
            Ele remove os valores opcionais que não possuem valor.

            flatMap: usado para transformar cada elemento em um array ou coleção e "achatar" o resultado em 
            um único array. Ele remove valores nulos ou opcionais e "achata" os sub-arrays resultantes em 
            um único array.
        */
    }

    static let allResorts: [Resort] = Bundle.main.decode("resorts.json")
    static let example = allResorts[0]
}
import Foundation

/*
    Esse script define 3 struct: Result, Query e Page. As struct Result e Query são usadas 
    para armazenar os resultados de uma consulta e a struct Page é usada para armazenar informações 
    sobre uma página específica. As struct implementam o protocolo Codable, o que significa que 
    elas podem ser codificadas e decodificadas para e de dados codificados, como JSON. 
    Isso é útil quando você precisa armazenar os resultados da consulta em um arquivo ou 
    enviá-los pela rede.

    A struct Page também implementa o protocolo Comparable, o que significa que ela pode ser 
    comparada com outras instâncias da mesma estrutura usando os operadores de comparação padrão, 
    como < e >. Nesse caso, as páginas são comparadas pelo título.
*/

struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [Int: Page]
}

struct Page: Codable, Comparable {

    /*
        O protocolo Comparable permite que você compare instâncias de um tipo personalizado 
        usando os operadores de comparação padrão, como <, >, <= e >=. Para adotar o protocolo Comparable, 
        o tipo precisa ser capaz de ser comparado de maneira consistente e significativa.

        Para adotar o protocolo Comparable, você deve implementar a operação de comparação < para o 
        seu tipo. Em seguida, os outros operadores de comparação são implementados automaticamente 
        com base na operação <.

        Documentação: https://developer.apple.com/documentation/swift/comparable
    */
    let pageid: Int
    let title: String
    let terms: [String: [String]]?

    var description: String {
        terms?["description"]?.first ?? "No further information"
    }

    static func <(lhs: Page, rhs: Page) -> Bool {

        /*
            Em Swift, os parâmetros lhs e rhs são usados como abreviação para 
            "left-hand side" (lado esquerdo) e "right-hand side" (lado direito), 
            respectivamente, e são comumente usados em operações de comparação e em 
            implementações de operadores.

            Os parâmetros lhs e rhs são usados como uma convenção para ajudar a tornar o 
            código mais legível e fácil de entender. No entanto, você pode usar qualquer 
            nome de parâmetro que desejar em suas implementações de operações e operadores.
        */
        lhs.title < rhs.title
    }
}
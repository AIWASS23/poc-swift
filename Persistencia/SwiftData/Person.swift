import Foundation
import SwiftData

@Model

/*
    A anotação @Model diz ao compilador Swift que esta classe é um modelo de dados. Essa anotação permite que 
    o compilador gere código que pode ser usado para armazenar e recuperar os dados do modelo de um 
    armazenamento persistente.

    A primeira linha importa os frameworks Foundation e SwiftData. A estrutura Foundation fornece 
    funcionalidade básica para trabalhar com dados, e a estrutura SwiftData fornece funcionalidade adicional 
    para trabalhar com modelos de dados. A próxima linha usa a anotação @Model para marcar a classe Person 
    como um modelo de dados. A linha final define a classe Person. A classe tem quatro propriedades: 
    personName, personAge, personIsHired e timeStamp. O inicializador init() usa o nome da pessoa, idade e 
    se ela foi contratada como parâmetros. O inicializador também define a propriedade timeStamp para a data 
    e hora atuais.
*/

final class Person {
  
    var personName: String
    var personAge: Int
    var personIsHired: Bool
    var timeStamp: Date
    
    init(personName: String, personAge: Int, personIsHired: Bool = false, timeStamp: Date) {
        self.personName = personName
        self.personAge = personAge
        self.personIsHired = personIsHired
        self.timeStamp = timeStamp
    }
}

/*
    O SwiftData é construído sobre o Core Data, então você pode ter certeza de que seus dados são mantidos de 
    forma confiável. No entanto, o SwiftData fornece uma API mais moderna e expressiva que facilita o 
    trabalho com dados. Principais recursos do SwiftData:

    Modelagem de dados declarativa: você pode definir seus modelos de dados usando código Swift regular, 
    facilitando a compreensão e a manutenção do seu código.

    Acesso rápido e eficiente a dados: SwiftData usa recursos de linguagem moderna, como macros, para gerar c
    ódigo eficiente para acessar dados.

    Acesso seguro aos dados: SwiftData usa segurança de tipo para evitar erros ao acessar dados.

    Integração perfeita com SwiftUI: SwiftData facilita a integração de modelos de dados com SwiftUI, para 
    que você possa exibir dados facilmente em suas interfaces de usuário.

    Se você está procurando uma estrutura de persistência poderosa e expressiva para Swift, SwiftData é uma 
    ótima opção. É fácil de usar, confiável e eficiente.

    Aqui estão alguns links para saber mais sobre o SwiftData:

    SwiftData | Documentação do desenvolvedor da Apple: https://developer.apple.com/documentation/swiftdata
    SwiftData: simplificando a persistência em aplicativos iOS: https://www.kodeco.com/40504096-swiftdata-simplifying-persistence-in-ios-apps
    Conheça o SwiftData: https://developer.apple.com/videos/play/wwdc2023/10187/
*/


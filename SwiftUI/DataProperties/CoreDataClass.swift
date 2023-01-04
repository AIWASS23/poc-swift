import Foundation
import CoreData

/*
    A classe Country herda de NSManagedObject. 
    NSManagedObject é uma classe do Core Data
    A anotação @objc(Country) é usada para permitir 
    que a classe seja exposta para o Objective-C
*/

@objc(Country)

/*
    NSManagedObject é uma classe do Core Data que permite armazenar e gerenciar 
    dados de objetos de forma persistente. Ela é usada para representar entidades 
    em um modelo de dados do Core Data e fornece uma interface para acessar e 
    gerenciar os dados dessas entidades.

    NSManagedObjects são criados a partir de uma entidade em um modelo de dados 
    e podem ter várias propriedades, que são definidas pelos atributos da entidade. 
    Podemos usar NSManagedObjects para criar, atualizar, excluir e recuperar objetos do banco de dados.
*/
public class Country: NSManagedObject {

}

@objc(Candy)
public class Candy: NSManagedObject {

}

@objc(Singer)
public class Singer: NSManagedObject {

}

@objc(Movie)
public class Movie: NSManagedObject {

}


/*
    Em SwiftUI, você pode exibir os dados de um objeto NSManagedObject 
    em uma interface do usuário usando um FetchRequest.

    Exemplo:

    import SwiftUI
    import CoreData

    struct ContentView: View {
        @FetchRequest(
            entity: Country.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Country.name, ascending: true)]
        ) var countries: FetchedResults<Country>

        var body: some View {
            List {
                ForEach(countries, id: \.self) { country in
                    Text(country.name)
                }
            }
        }
    }

    Isso criaria uma lista de Text views, cada um exibindo o nome de um país. 
    O FetchRequest é usado para recuperar os objetos Country do banco de dados 
    e o FetchedResults é usado para armazenar os resultados da solicitação.

    Podemos usar NSManagedObjects em SwiftUI para criar, atualizar e excluir objetos 
    em seu banco de dados. Isso pode ser feito usando o método managedObjectContext.save().

    import CoreData

    func addCountry() {
        let newCountry = Country(context: managedObjectContext)
        newCountry.name = "New Country"
        try? managedObjectContext.save()
    }
*/

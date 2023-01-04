import Foundation
import CoreData

/*
    A extensão para a classe Country, que é uma subclasse de NSManagedObject, é usada 
    para representar uma entidade "país" no seu modelo de dados do Core Data e tem duas propriedades, 
    "fullName" (nome completo) e "shortName" (nome curto). Ela também tem uma relação com a 
    entidade "Candy" (doces), que é representada por uma propriedade "candy".

    A extensão define uma função estática chamada "fetchRequest", que é usada para recuperar 
    objetos Country do banco de dados. Ela também define alguns métodos que são usados 
    para acessar e manipular os dados das propriedades da classe. Por exemplo, 
    o método "wrappedShortName" é usado para retornar o nome curto de um país, ou 
    "Unknown Country" (país desconhecido) se o nome curto for nulo. 
    O método "candyArray" é usado para retornar uma lista de doces ordenados pelo nome, 
    a partir da propriedade "candy".

    A extensão também define quatro métodos que são gerados automaticamente pelo Xcode 
    para gerenciar a relação "candy". Esses métodos são usados para adicionar ou 
    remover objetos Candy da propriedade "candy" de um objeto Country.
*/


extension Country {

    /*
        A anotação @nonobjc é usada em Swift para indicar que um membro de uma classe, 
        estrutura ou enumeração não deve ser exposto para o Objective-C. Isso significa que o 
        membro não pode ser acessado a partir de código Objective-C ou usando o método de 
        mensagem do Objective-C.

        A anotação @nonobjc é útil quando você deseja esconder um membro de uma classe de código 
        escrito em Objective-C, mas ainda permitir que ele seja acessado de código Swift. 
        Isso pode ser útil para evitar conflitos de nome ou para garantir 
        que um membro não seja modificado de forma inesperada por código Objective-C.
    */

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Country> {

        /*
            NSFetchRequest é uma classe do Core Data que permite armazenar e gerenciar dados de objetos 
            de forma persistente. É usado para recuperar objetos de um banco de dados 
            gerenciado pelo Core Data.

            Para criar uma solicitação de recuperação, você precisa especificar a 
            entidade que deseja recuperar e, opcionalmente, um conjunto de critérios para 
            filtrar os resultados. Você também pode especificar um conjunto de ordenação para 
            classificar os resultados e um limite para limitar o número de resultados retornados.

            Exemplo: recuperar objetos em ordem alfabetica.

            import CoreData

            let fetchRequest = NSFetchRequest<Country>(entityName: "Country")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

            do {
                let countries = try managedObjectContext.fetch(fetchRequest)
                // use a matriz de Country aqui
            } catch {
                // lidar com o erro
            }

            Podemos usar predicates (predicados) para filtrar os resultados da solicitação de recuperação.

            Exemplo: países com mais de 1mi de habitantes.

            import CoreData

            let fetchRequest = NSFetchRequest<Country>(entityName: "Country")
            fetchRequest.predicate = NSPredicate(format: "population > 1000000")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

            do {
                let countries = try managedObjectContext.fetch(fetchRequest)
                // use a matriz de Country aqui
            } catch {
                // lidar com o erro
            }
        */
        return NSFetchRequest<Country>(entityName: "Country")
    }

    /*
        A anotação @NSManaged é usada em Swift para indicar que uma propriedade ou método é 
        gerenciado pelo Core Data. Isso significa que o valor da propriedade ou o comportamento 
        do método são gerenciados pelo Core Data e não pelo código Swift.

        A anotação @NSManaged é usada principalmente em subclasses de NSManagedObject, 
        que são usadas para representar entidades no modelo de dados do Core Data. 
        Quando você cria uma subclasse de NSManagedObject, pode definir propriedades 
        e métodos gerenciados pelo Core Data adicionando a anotação @NSManaged a eles.
    */

    @NSManaged public var fullName: String?
    @NSManaged public var shortName: String?

    /*
        NSSet é uma classe do Foundation que representa um conjunto não ordenado de objetos únicos. 
        Um conjunto é uma coleção de valores que não estão em nenhuma ordem específica e não 
        permitem elementos duplicados.

        Exemplo:

        let set = NSSet()
        let set2 = NSSet(array: [1, 2, 3, 4])

        Podemos adicionar ou remover elementos de um conjunto usando os métodos "add" e "remove". 
        Também podemos verificar se um conjunto contém um elemento específico usando o método "contains".

        var set = NSSet(array: [1, 2, 3, 4])
        set.add(5)
        set.remove(4)

        let containsFive = set.contains(5)  // true
        let containsFour = set.contains(4)  // false

        Iteramos sobre os elementos de um conjunto usando um laço "for-in" ou convertendo o 
        conjunto para um array e iterando sobre os elementos do array.

        Exemplo:

        let set = NSSet(array: [1, 2, 3, 4])

        for element in set {
            print(element)
        }

        let array = set.allObjects as! [Int]
        for element in array {
            print(element)
        }

        Você também pode usar operadores de conjunto para realizar operações 
        com conjuntos, como união, intersecção e diferença.

        Exemplo:

        let set1 = NSSet(array: [1, 2, 3, 4])
        let set2 = NSSet(array: [3, 4, 5, 6])

        let union = set1.union(set2)   // [1, 2, 3, 4, 5, 6]
        let intersection = set1.intersect(set2)  // [3, 4]
        let difference = set1.minus(set2)  // [1, 2]
    */
    @NSManaged public var candy: NSSet?

    public var wrappedShortName: String {
        shortName ?? "Unknown Country"
    }

    public var wrappedFullName: String {
        fullName ?? "Unknown Country"
    }

    public var candyArray: [Candy] {
        let set = candy as? Set<Candy> ?? []
        return set.sorted {
            
            /*
                Em Swift, o símbolo "$0" é usado como uma referência ao primeiro argumento de uma closure 
                (bloco de código) ou função. Ele é usado como uma forma concisa de acessar 
                o primeiro argumento de uma closure quando ele é usado como um parâmetro de uma função.

                O símbolo "$0" também pode ser usado para se referir aos argumentos subsequentes 
                de uma closure, usando índices consecutivos. Por exemplo, para acessar o segundo 
                argumento de uma closure, você pode usar o símbolo "$1", para o terceiro argumento, 
                o símbolo "$2", e assim por diante.
            */
            $0.wrappedName < $1.wrappedName
        }
    }
}

// - MARK: Generated accessors for candy

extension Country {

    @objc(addCandyObject:)
    @NSManaged public func addToCandy(_ value: Candy)

    @objc(removeCandyObject:)
    @NSManaged public func removeFromCandy(_ value: Candy)

    @objc(addCandy:)
    @NSManaged public func addToCandy(_ values: NSSet)

    @objc(removeCandy:)
    @NSManaged public func removeFromCandy(_ values: NSSet)

}

/*
    A extensão para a classe Candy, que é uma subclasse de NSManagedObject. 
    A extensão adiciona um método de classe chamado "fetchRequest" que retorna uma 
    solicitação de recuperação para a entidade "Candy".

    A extensão também adiciona duas propriedades gerenciadas pelo Core Data: "name" e "origin". 
    A propriedade "wrappedName" é uma propriedade computada que retorna o valor da propriedade 
    "name", ou "Unknown Candy" se a propriedade "name" for nula.

    Essa extensão pode ser usada para recuperar objetos Candy do banco de dados 
    gerenciado pelo Core Data e para acessar e modificar as propriedades de um objeto Candy.


*/

extension Candy {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Candy> {
        return NSFetchRequest<Candy>(entityName: "Candy")
    }

    @NSManaged public var name: String?
    @NSManaged public var origin: Country?

    public var wrappedName: String {
        name ?? "Unknown Candy"
    }
}

/*
    A extensão para a classe Singer, que é uma subclasse de NSManagedObject. 
    A extensão adiciona um método de classe chamado "fetchRequest" que retorna uma solicitação 
    de recuperação para a entidade "Singer".

    A extensão também adiciona duas propriedades gerenciadas pelo Core Data: "firstName" e "lastName". 
    As propriedades "wrappedFirstName" e "wrappedLastName" são propriedades computadas que retornam o 
    valor das propriedades "firstName" e "lastName", respectivamente, ou "Unknown" 
    se essas propriedades forem nulas.

    Essa extensão pode ser usada para recuperar objetos Singer do banco de dados gerenciado 
    pelo Core Data e para acessar e modificar as propriedades de um objeto Singer.
*/

extension Singer {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Singer> {
        return NSFetchRequest<Singer>(entityName: "Singer")
    }

    @NSManaged public var lastName: String?
    @NSManaged public var firstName: String?

    var wrappedFirstName: String {
        firstName ?? "Unknown"
    }

    var wrappedLastName: String {
        lastName ?? "Unknown"
    }
}

/*
    A extensão para a classe Movie, que é uma subclasse de NSManagedObject. 
    A extensão adiciona um método de classe chamado "fetchRequest" que retorna uma solicitação 
    de recuperação para a entidade "Movie".

    A extensão também adiciona três propriedades gerenciadas pelo Core Data: "title", "director" e "year". 
    Essas propriedades são usadas para armazenar informações sobre um filme, como o título, o diretor 
    e o ano de lançamento.

    Essa extensão pode ser usada para recuperar objetos Movie do banco de dados gerenciado pelo Core Data 
    e para acessar e modificar as propriedades de um objeto Movie.
*/

extension Movie {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var title: String
    @NSManaged public var director: String
    @NSManaged public var year: Int16
}

import CoreData

@objc(Destination)

/*
    @objc(Destination) é uma anotação em Swift que permite definir o nome do objeto gerado pela classe 
    ou protocolo no runtime Objective-C. Essa anotação é necessária quando você trabalha com 
    Objective-C em um projeto Swift, ou quando você precisa usar APIs que só estão disponíveis em 
    Objective-C.

    Nesse caso, a anotação @objc(Destination) indica que a classe Destination pode ser usada em 
    códigos Objective-C e que ela é identificada com o nome "Destination" nesse contexto.
*/
public class Destination: NSManagedObject {}

extension Destination {
    @nonobjc

    /*
        O atributo @nonobjc é usado em Swift para indicar que um membro de classe ou método não deve 
        ser exposto para Objective-C. Ele é usado para evitar a criação desnecessária de objetos 
        Objective-C para esses membros, o que pode melhorar o desempenho do aplicativo. Normalmente, 
        isso é usado em membros de classe ou métodos que só serão acessados internamente pelo código 
        Swift e não precisam ser expostos para o Objective-C.
    */

    public class func fetchRequest() -> NSFetchRequest<Destination> {
        return NSFetchRequest<Destination>(entityName: "Destination")
    }

    @NSManaged public var caption: String
    @NSManaged public var createdAt: Date
    @NSManaged public var details: String
    @NSManaged public var id: UUID
    @NSManaged public var image: Data?

    /*
        @NSManaged é um atributo em Core Data que indica que a propriedade de um objeto gerenciado é 
        dinâmica e que seus métodos acessadores devem ser fornecidos em tempo de execução. Ao usar 
        Core Data com Swift, as propriedades de uma subclasse de objeto gerenciado marcadas com o 
        atributo @NSManaged não recebem uma implementação do compilador. Em vez disso, a estrutura de 
        Core Data fornece uma implementação em tempo de execução, que permite que as propriedades 
        sejam suportadas pelo armazenamento de Core Data.

        Portanto, você usa @NSManaged para declarar uma propriedade em uma subclasse de objeto 
        gerenciado sem fornecer uma implementação para seus métodos getter e setter.
    */
}

// MARK: Identifiable
extension Destination: Identifiable {}

/*
    A classe Destination herda de NSManagedObject e representa uma entidade gerenciada pelo Core Data. 
    A classe é usada para representar um objeto de destino que possui propriedades como caption, 
    createdAt, details, id e image. As propriedades são marcadas com @NSManaged, o que significa que 
    são gerenciadas pelo Core Data.

    O método fetchRequest() é usado para obter uma solicitação de busca de NSFetchRequest para 
    recuperar instâncias da entidade Destination. O entityName é definido como "Destination", que deve 
    corresponder ao nome da entidade definida no arquivo de modelo do Core Data.

    O protocolo Identifiable é adotado por Destination, o que significa que ele tem uma propriedade 
    id. Isso é útil em combinação com outras APIs do SwiftUI, como List, que requerem que os itens na 
    lista tenham uma identidade exclusiva.
*/

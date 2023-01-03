import CoreData
import Foundation

/*
    O DataController gerencia o acesso ao Core Data em um aplicativo. 
    A classe tem uma propriedade container, que é um contêiner de persistência 
    do Core Data que armazena as informações de modelo de dados e as operações de persistência.

    A classe também tem um inicializador que carrega o contêiner de persistência a 
    partir de um arquivo de modelo de dados chamado "Bookworm". 
    Se o contêiner não puder ser carregado (por exemplo, se o arquivo de modelo 
    de dados estiver ausente ou estiver corrompido), um erro é exibido no console.

    A classe DataController também estende a classe ObservableObject do SwiftUI. 
    Isso significa que a classe pode ser usada como uma fonte de dados observáveis 
    para atualizar automaticamente as visualizações quando os dados mudam. 
    Para fazer isso, basta anexar a classe a uma visualização como um objeto de ambiente:

    @EnvironmentObject var dataController: DataController
*/

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Bookworm")

    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
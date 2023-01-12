import SwiftUI

/*
    A classe Prospect representa um prospecto, com propriedades como nome, endereço de e-mail e se o 
    prospecto já foi contatado ou não. A classe Prospect implementa os protocolos Identifiable e Codable, 
    o que significa que ela pode ser usada como um tipo de dados codificável e identificável pelo SwiftUI.

    Ele também cria uma classe Prospects que é marcada como @MainActor. Essa classe é usada para gerenciar 
    uma lista de prospectos e fornece funcionalidades para adicionar um novo prospecto e alternar o estado 
    de contato de um prospecto existente. A classe Prospects implementa o protocolo ObservableObject e usa 
    a propriedade @Published para sinalizar ao SwiftUI quando a lista de prospectos é alterada.

    A classe Prospects usa o UserDefaults para salvar e carregar os dados de prospectos em disco. 
    Quando a classe é inicializada, ela tenta carregar os dados salvos do UserDefaults usando o JSONDecoder.
    Se não houver dados salvos, uma lista vazia é criada. Quando um novo prospecto é adicionado ou o estado 
    de contato de um prospecto existente é alterado, essas alterações são salvas novamente no UserDefaults 
    usando o JSONEncoder.
*/

class Prospect: Identifiable, Codable {
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    fileprivate(set) var isContacted = false
}

@MainActor class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect]
    let saveKey = "SavedData"

    init() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {

                /*
                    O JSONDecoder é uma classe no SwiftUI que permite a decodificação de dados JSON em 
                    objetos Swift. Ele é parte da biblioteca padrão do Swift e é fácil de usar. Você pode 
                    criar uma instância de JSONDecoder e, em seguida, chamar o método decode(_:from:) para 
                    decodificar um objeto a partir de uma representação JSON.

                    Também é possível personalizar a decodificação JSON, por exemplo, para trabalhar com 
                    formatos de data diferentes ou para decodificar tipos personalizados, você pode 
                    fornecer suas próprias estratégias de decoding usando o protocolo DateDecodingStrategy 
                    e KeyDecodingStrategy.

                    O JSONEncoder é uma classe do SwiftUI que permite codificar objetos Swift em um 
                    formato de dados JSON (JavaScript Object Notation). Ele funciona de maneira semelhante 
                    ao JSONEncoder do Foundation, mas é específico para uso com o SwiftUI. Ele é usado para 
                    serializar objetos em dados que podem ser enviados em uma requisição HTTP ou 
                    armazenados em um arquivo. Ele também pode ser usado para codificar objetos de modelo 
                    para que eles possam ser armazenados localmente.
                */

                people = decoded
                return
            }
        }

        // no saved data!
        people = []
    }

    private func save() {
        if let encoded = try? JSONEncoder().encode(people) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }

    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }

    func toggle(_ prospect: Prospect) {
        objectWillChange.send()

        /*
            objectWillChange é uma propriedade publisher do SwiftUI que é usada para emitir notificações 
            quando um objeto for modificado. Ele é usado principalmente com objetos de modelo que são 
            usados ​​em conjunto com views SwiftUI para atualizar automaticamente a interface do usuário 
            quando os dados do modelo mudam. Ele é especialmente útil quando se trabalha com objetos de 
            modelo que podem ser modificados fora da thread principal, como resultado de uma chamada de 
            rede assíncrona.
        */
        
        prospect.isContacted.toggle()
        save()
    }
}

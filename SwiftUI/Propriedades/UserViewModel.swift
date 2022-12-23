import Foundation

/*
   O ObservableObject é um protocolo do SwiftUI que 
   permite criar classes que podem ser observadas pelas visualizações.
   Para usar ObservableObject, basta fazer com que a classe seja 
   conforme ao protocolo e marcar as propriedades 
   que deseja observar com o @Published property wrapper. 
   Isso fará com que o SwiftUI automaticamente atualize as 
   visualizações que dependem dessas propriedades sempre que elas forem alteradas.
*/

class User: ObservableObject {

    /*
        O @Published é um property wrapper do SwiftUI que permite marcar 
        propriedades de um objeto observável para que as visualizações sejam 
        atualizadas automaticamente quando essas propriedades mudam. 
        Para usar @Published, basta adicioná-lo ao lado de 
        qualquer propriedade que você deseja observar em um objeto que seja um 
        ObservableObject protocol. Isso fará com que o SwiftUI 
        automaticamente atualize as visualizações que dependem 
        dessa propriedade sempre que ela for alterada.
    */

    @Published var items = [UserItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }

    init() {

        /*
            UserDefaults é um tipo de armazenamento de dados no 
            iOS, macOS, watchOS e tvOS que permite armazenar 
            pequenas quantidades de dados de configuração entre sessões de usuário. 
            É uma maneira conveniente de armazenar configurações de usuário, 
            como preferências de aplicativo, que podem ser usadas em todos os dispositivos do usuário.

            Para usar UserDefaults, primeiro você deve importar o framework Foundation. 
            Em seguida, podemos acessar a instância compartilhada de UserDefaults 
            usando a propriedade standard. Podemos usar os métodos set e object(forKey:) 
            para armazenar e recuperar dados, respectivamente.

            EXEMPLO

            let userDefaults = UserDefaults.standard

            // Armazenar um valor
            userDefaults.set(true, forKey: "showNotifications")

            // Recuperar um valor
            let showNotifications = userDefaults.bool(forKey: "showNotifications")

            UserDefaults armazena os dados em um arquivo de sistema e os 
            recupera automaticamente na próxima vez que o aplicativo for iniciado. 
            Isso é útil para armazenar configurações de usuário que precisam ser 
            mantidas entre sessões de usuário. No entanto, é importante lembrar que 
            UserDefaults não é um armazenamento de dados seguro e não deve ser 
            usado para armazenar senhas ou outras informações confidenciais.
        */

        if let savedItems = UserDefaults.standard.data(forKey: "Items") {

            /*
                JSONDecoder é um tipo da biblioteca padrão do Swift que permite 
                decodar (converta) dados codificados em JSON em tipos Swift, 
                como Dictionary ou tipos personalizados conforme ao Decodable protocol. 
                Isso é útil quando você quer trabalhar com dados JSON em sua aplicação Swift.

                Para usar JSONDecoder, primeiro você precisa importar o framework Foundation. 
                Em seguida, você pode criar uma instância de JSONDecoder 
                e chamar o método decode(_:from:) para converter os dados JSON em um tipo Swift.

                EXEMPLO

                let jsonData = """
                    {
                        "name": "John",
                        "age": 30,
                        "country": "United States"
                    }
                """.data(using: .utf8)!

                struct User: Decodable {
                    var name: String
                    var age: Int
                    var country: String
                }

                let decoder = JSONDecoder()
                let user = try decoder.decode(User.self, from: jsonData)
                print(user.name)  // "John"

            */

            if let decodedItems = try? JSONDecoder().decode([UserItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }

        items = []
    }
}
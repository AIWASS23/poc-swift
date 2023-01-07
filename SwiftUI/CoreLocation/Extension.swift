/*
    A classe ViewModel é um modelo de visualização observável que é usado para gerenciar 
    o estado da aplicação e fornecer dados à visualização principal. Ele tem as seguintes 
    responsabilidades:

    Armazenar os dados dos locais no mapa (a propriedade locations).
    Armazenar a região de coordenadas atualmente exibida no mapa (a propriedade mapRegion).
    Armazenar a anotação do local selecionado pelo usuário (a propriedade selectedPlace).
    Armazenar o estado de "desbloqueado" da aplicação (a propriedade isUnlocked).
    Fornecer métodos para adicionar, editar e excluir locais (os métodos addLocation(), update(location:)
*/

import Foundation

/*
    O framework LocalAuthentication fornece APIs para autenticação de usuários 
    no iOS, macOS, watchOS e tvOS. Ele permite que os aplicativos solicitem a 
    autenticação de um usuário usando diferentes métodos, como digitalização 
    de impressão digital, reconhecimento facial ou senha.
    EXEMPLO:

    import LocalAuthentication

    let context = LAContext()
    var error: NSError?

    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
        let reason = "Please authenticate yourself to access the app."

        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
            if success {
                // autenticado com sucesso
            } else {
                // falha na autenticação
            }
        }
    } else {
        // autenticação biométrica não disponível
    }

    Nesse exemplo, o método canEvaluatePolicy(_:error:) é usado para verificar 
    se o dispositivo tem uma forma de autenticação biométrica habilitada. 
    Se sim, o método evaluatePolicy(_:localizedReason:reply:) é chamado para 
    solicitar a autenticação do usuário. Se a autenticação for bem-sucedida, 
    o código dentro do bloco de sucesso será executado; caso contrário, o 
    código dentro do bloco de falha será executado.

    Mais informações: https://developer.apple.com/documentation/localauthentication
*/

import LocalAuthentication
import MapKit

extension ContentView {

    /*
        @MainActor é um atributo do SwiftUI que pode ser usado para indicar que uma determinada 
        classe ou estrutura deve ser criada e gerenciada pelo ator principal do aplicativo.

        O "ator principal" é um objeto responsável por gerenciar a lógica de negócios e os 
        dados da aplicação, incluindo a interface do usuário. Ele é criado e gerenciado 
        pelo framework SwiftUI e é responsável por atualizar a interface do usuário de 
        acordo com os dados que ele gerencia.

        O atributo @MainActor é usado para indicar que uma classe ou estrutura deve ser 
        criada e gerenciada pelo ator principal, em vez de ser criada e gerenciada pelo 
        objeto que a criou. Isso pode ser útil para garantir que os objetos da interface 
        do usuário são atualizados corretamente quando os dados sob os quais eles dependem são alterados.
    */
    @MainActor class ViewModel: ObservableObject {
        @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
        @Published private(set) var locations: [Location]
        @Published var selectedPlace: Location?
        @Published var isUnlocked = false

        let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPlaces")

        /*
            O FileManager é uma classe do Foundation que fornece métodos para gerenciar arquivos e 
            diretórios no sistema de arquivos do dispositivo. Ele permite que você crie, 
            exclua, mover, copiar e pesquise por arquivos e diretórios e obtenha informações sobre eles.
            EXEMPLO: 

            import Foundation

            let documentsDirectory = FileManager.default.urls(
                for: .documentDirectory, in: .userDomainMask).first!
            print(documentsDirectory)

            Nesse exemplo, o método urls(for:in:) é usado para obter o URL para o diretório de 
            documentos do aplicativo. O primeiro item da lista de URLs é então recuperado e 
            impresso na saída.

            Documentação: https://developer.apple.com/documentation/foundation/filemanager

            Aqui estão alguns dos principais métodos da classe FileManager:

            default: retorna uma instância compartilhada do FileManager.

            urls(for:in:): retorna uma lista de URLs para o diretório especificado no 
            espaço de nome de domínio especificado.

            contentsOfDirectory(at:includingPropertiesForKeys:options:): retorna um array com os 
            nomes dos itens no diretório especificado.

            createDirectory(at:withIntermediateDirectories:attributes:): cria um novo diretório no 
            caminho especificado.

            createFile(atPath:contents:attributes:): cria um novo arquivo no caminho especificado 
            com os dados e atributos fornecidos.

            copyItem(at:to:): copia um item de um caminho para outro.

            moveItem(at:to:): move um item de um caminho para outro.

            removeItem(at:): remove um item do caminho especificado.

            fileExists(atPath:): verifica se o item existe no caminho especificado.

            isReadableFile(atPath:): verifica se o item no caminho especificado pode ser lido.

            isWritableFile(atPath:): verifica se o item no caminho especificado pode ser modificado.

            isExecutableFile(atPath:): verifica se o item no caminho especificado pode ser executado.

            attributesOfItem(atPath:): retorna um dicionário com os atributos do item no caminho especificado.
        */

        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }

        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Unable to save data.")
            }
        }

        func addLocation() {
            let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
            locations.append(newLocation)
            save()
        }

        func update(location: Location) {
            guard let selectedPlace = selectedPlace else { return }

            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
                save()
            }
        }

        func authenticate() {
            let context = LAContext()

            /*
                LAContext é uma classe do framework LocalAuthentication que representa um contexto 
                de autenticação. Ela é usada para configurar e avaliar políticas de autenticação 
                e fornecer feedback ao usuário durante o processo de autenticação.
                Documetação: https://developer.apple.com/documentation/localauthentication/lacontext
            */

            var error: NSError?

            /*
                NSError é uma classe do framework Foundation que representa um erro ocorrido durante a 
                execução de um método. Ela fornece informações sobre o erro, como o código de erro e a 
                descrição do erro.

                Muitas vezes, podemos passar uma referência a uma variável de erro como um parâmetro 
                de um método e, se o método falhar, ele preencherá a variável com uma instância 
                de NSError contendo informações sobre o erro ocorrido.
                EXEMPLO:

                import Foundation

                var error: NSError?
                let success = doSomethingThatCanFail(&error)

                if success {
                    // faça algo no sucesso
                } else {
                    // verifique a variável de erro para obter mais informações sobre a falha
                }

                func doSomethingThatCanFail(_ error: NSErrorPointer) -> Bool {
                    // fazer algo que pode falhar
                    // se falhar, defina a variável de erro e retorne false
                    return true
                }

                Nesse exemplo, o método doSomethingThatCanFail(_:) aceita uma referência a uma 
                variável de erro como parâmetro. Se o método falhar, ele pode preencher a variável 
                de erro com uma instância de NSError contendo informações sobre o erro ocorrido 
                e retornar false. Se o método for bem-sucedido, ele retorna true.

                Documentação: https://developer.apple.com/documentation/foundation/nserror
            */

            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {

                /*
                    Em Swift, a sintaxe &error é usada para passar uma referência a uma variável de 
                    erro como um parâmetro de um método. Isso permite que o método altere o valor 
                    da variável de erro se ocorrer um erro durante a execução do método.

                    Em Swift, o símbolo "&"" é usado para representar uma referência a uma variável. 
                    Quando é usado antes de uma variável, ele indica que esta é uma referência ao 
                    valor armazenado na variável em vez do valor em si.

                    EXEMPLO:
                    import Foundation

                    var x = 10
                    doSomething(with: &x)
                    print(x) // prints "20"

                    func doSomething(with value: inout Int) {
                        value += 10
                    }

                    Nesse exemplo, o método doSomething(with:) aceita uma referência à variável x 
                    como parâmetro. Quando o método é chamado, a variável x é passada como uma 
                    referência usando o símbolo &. Dentro do método, a variável value é uma referência 
                    à mesma posição de memória que a variável x, então quando value é modificada, 
                    o valor de x também é alterado. Quando o método é chamado, o valor de x é 
                    impresso como 20.




                */
                let reason = "Please authenticate yourself to unlock your places."

                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    if success {
                        Task { @MainActor in
                            self.isUnlocked = true
                        }
                    } else {
                        // error
                    }
                }
            } else {
                // no biometrics
            }
        }
    }
}

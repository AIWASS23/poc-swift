import Foundation

/*
    Este script é uma extensão da classe Bundle do Foundation, que é usada para gerenciar recursos de 
    arquivos em um aplicativo iOS ou macOS. Ele adiciona uma função chamada decode(_:) que permite 
    decodificar facilmente um arquivo de um pacote de recursos (bundle) para um tipo Decodable.

    A função decode(_:) tem um parâmetro chamado "file" que é o nome do arquivo que deseja-se decodificar. 
    Ele então usa o método url(forResource:withExtension:) da classe Bundle para obter o URL do arquivo 
    especificado. Se o arquivo não puder ser localizado, o script lança um erro fatal.

    Em seguida, ele carrega os dados do arquivo usando a classe Data e cria um objeto JSONDecoder para 
    decodificar os dados. Ele então tenta decodificar os dados para o tipo especificado usando o método 
    decode(_:from:) do decodificador. Se a decodificação falhar, o script lança um erro fatal.

    Finalmente, ele retorna o objeto decodificado.

    Esse script permite uma forma mais fácil e concisa de decodificar arquivos de recursos em um aplicativo 
    Swift, pois ele encapsula toda a lógica de encontrar e decodificar o arquivo em uma única função. 
    Ao invocar esse método, você pode decodificar um arquivo facilmente passando apenas o nome do arquivo 
    e o tipo de objeto esperado, sem precisar se preocupar com a lógica de encontrar e decodificar 
    o arquivo manualmente.
*/

extension Bundle {
    func decode<T: Decodable>(_ file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()

        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }

        return loaded
    }
}

/*
    Bundle é uma classe presente no framework Foundation do iOS e macOS que é usada para gerenciar recursos 
    de arquivos em um aplicativo. Ela é usada para localizar, carregar e gerenciar os recursos de arquivos 
    incluídos em um aplicativo, como imagens, áudios, vídeos, arquivos de história e muito mais.

    A classe Bundle oferece métodos para encontrar recursos em um aplicativo, 
    como url(forResource:withExtension:) e path(forResource:ofType:), que permitem encontrar o caminho de 
    arquivos incluídos em um aplicativo. Além disso, ela fornece informações sobre o aplicativo, como a 
    versão, o identificador e o nome do pacote, através de propriedades como bundleIdentifier, bundleURL e 
    bundlePath.

    A classe Bundle é utilizada comumente para carregar recursos estáticos como imagens, áudios, etc. 
    Ela também é usada para carregar arquivos de configuração, como arquivos de recursos localizáveis e 
    arquivos de configuração de aplicativos.



*/

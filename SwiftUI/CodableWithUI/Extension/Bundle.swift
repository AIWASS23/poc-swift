import Foundation

extension Bundle {
    func decode<T: Codable>(_ file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)

        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }

        return loaded
    }
}
/*
    Esse script define uma extensão (extension) para a classe Bundle em Swift, 
    que é um tipo que representa um pacote de recursos em um aplicativo. 
    A extensão adiciona uma função decode que permite que você decode um arquivo 
    como um determinado tipo codificável (T: Codable) que é especificado como um 
    parâmetro de tipo genérico.

    A função tenta localizar o arquivo especificado no parâmetro file dentro do pacote de recursos 
    do aplicativo usando o método url(forResource:withExtension:) da classe Bundle. 
    Se o arquivo não puder ser localizado, 
    a função lança uma exceção com a mensagem "Falha ao localizar o arquivo no pacote".

    Em seguida, a função tenta ler os dados do arquivo usando o inicializador Data(contentsOf:). 
    Se os dados não puderem ser lidos, a função lança uma exceção 
    com a mensagem "Falha ao carregar o arquivo do pacote".

    A seguir, a função cria um novo decodificador JSON usando o tipo JSONDecoder 
    e configura sua estratégia de decodificação de data para usar um DateFormatter 
    com o formato "y-MM-dd". Isso significa que, quando o decodificador encontrar uma data no JSON, 
    ele tentará decodificá-la usando esse formato de data.

    Por fim, a função tenta decodificar o tipo T a partir dos dados lidos usando o método decode(_:from:) 
    do decodificador JSON. Se a decodificação falhar, a função lança uma exceção 
    com a mensagem "Falha ao decodificar o arquivo do pacote". 
    Se a decodificação for bem-sucedida, a função retorna o valor decodificado.
*/
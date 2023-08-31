import UIKit
import Foundation

extension UIView {

    func addSubviews(_ views: UIView...) {
        views.forEach({
            addSubview($0)
        })
    }
}

extension String {

    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    static func shortenTimeFormatter(timeInterval: Double) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: TimeInterval(timeInterval))
    }

    static func minuteAndSecondFormatter(timeInterval: Double) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .spellOut
        return formatter.string(from: TimeInterval(timeInterval))!
    }

    /*
        A extensão String adiciona três métodos:

        O método capitalizeFirstLetter retorna uma nova string com a primeira letra em maiúscula e 
        todas as outras letras em minúsculas.

        O método shortenTimeFormatter retorna uma representação legível do tempo em minutos e segundos. 
        Ele usa um DateComponentsFormatter para formatar o tempo em uma string no estilo posicional 
        (por exemplo, "01:30").

        O método minuteAndSecondFormatter também retorna uma representação legível do tempo em minutos 
        e segundos. Ele usa um DateComponentsFormatter para formatar o tempo em uma string por extenso 
        (por exemplo, "um minuto e trinta segundos").
    */
}

extension Bundle {

    func decode<T: Decodable>(_ type: T.Type, from file: String) -> T? {
        guard let urlQuery = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: urlQuery) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()

        do {
            let loaded = try decoder.decode(T.self, from: data)
            return loaded
        } catch(let error) {
            print(error)
        }

        return nil

        /*
            A extensão Bundle adiciona um método genérico decode que pode ser usado para carregar um 
            arquivo JSON da pasta de recursos do aplicativo e decodificá-lo em um objeto de um tipo 
            específico que implementa o protocolo Decodable. Se houver um erro ao carregar ou 
            decodificar o arquivo JSON, o método retorna nulo e exibe um erro.
        */
    }
}
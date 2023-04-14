import Foundation

public enum SecureStoreError: Error {
    case string2DataConversionError
    case data2StringConversionError
    case unhandledError(message: String)
}

extension SecureStoreError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .string2DataConversionError:
            return NSLocalizedString("String to Data conversion error", comment: "")
        case .data2StringConversionError:
            return NSLocalizedString("Data to String conversion error", comment: "")
        case .unhandledError(let message):
            return NSLocalizedString(message, comment: "")
        }
    }
}

/*
 SecureStoreError representa os possíveis erros que podem ocorrer durante a utilização da estrutura SecureStore mencionada anteriormente. O enum SecureStoreError adota o protocolo Error, tornando-o um tipo de erro que pode ser lançado e capturado em blocos do-catch em Swift.

 O enum SecureStoreError possui três casos de erro:

 string2DataConversionError: Representa um erro de conversão de string para dados.

 data2StringConversionError: Representa um erro de conversão de dados para string.

 unhandledError(message: String): Representa um erro não tratado com uma mensagem de erro personalizada.
 
 Além disso, o enum SecureStoreError estende o protocolo LocalizedError, que define um requisito para fornecer uma descrição localizada do erro por meio da propriedade computada errorDescription. O código implementa essa propriedade de forma que, para cada caso de erro, seja retornada uma descrição localizada correspondente utilizando a função NSLocalizedString, que permite a internacionalização de mensagens de erro com base no idioma do dispositivo do usuário.
*/

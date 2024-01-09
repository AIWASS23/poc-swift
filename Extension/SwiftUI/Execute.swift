import Foundation
import SwiftUI

/*
a classe chamada Execute que oferece métodos estáticos para executar blocos de código em diferentes contextos de 
despacho de fila (dispatch queue) no Swift usando a DispatchQueue.

// Executando um bloco de código na main thread
Execute.onMain {
    // Código a ser executado na main thread
    // Por exemplo, atualizações de interface do usuário (UI)
}

// Executando um bloco de código após um atraso de 2 segundos
Execute.afterDelay(seconds: 2) {
    // Código a ser executado após o atraso de 2 segundos
}

*/

class Execute {
    typealias Perform = () -> Void
    
    static func onMain(perform: @escaping Perform) {
        DispatchQueue.main.async {
            perform()
        }
    }
    
    static func afterDelay(seconds:Double, perform: @escaping Perform) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            perform()
        }
    }
}

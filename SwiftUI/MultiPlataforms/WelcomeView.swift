import SwiftUI

struct WelcomeView: View {

    /*
        var body: some View é uma declaração de variável em SwiftUI. some View é um tipo específico de 
        protocolo genérico que indica que a variável "body" contém uma exibição (ou seja, um elemento visual) 
        na interface do usuário. Esse tipo específico de protocolo genérico é usado para garantir que a 
        exibição contida na variável "body" atenda aos requisitos de layout e apresentação especificados 
        pelo SwiftUI.
    */

    var body: some View {
        VStack {
            Text("Bem-Vindo!!!")
                .font(.largeTitle)

            Text("Escolha alguma opção")
                .foregroundColor(.secondary)
        }
    }
}
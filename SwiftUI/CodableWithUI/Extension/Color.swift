import Foundation
import SwiftUI

extension ShapeStyle where Self == Color {
    static var darkBackground: Color {
        Color(red: 0.1, green: 0.1, blue: 0.2)
    }

    static var lightBackground: Color {
        Color(red: 0.2, green: 0.2, blue: 0.3)
    }
}

/*
    Esse script define uma extensão do tipo ShapeStyle para o tipo Color, 
    permitindo que os métodos darkBackground e lightBackground sejam usados 
    como estilos de forma para cores.

    A extensão é limitada ao tipo Color usando a cláusula where Self == Color. 
    Isso significa que os métodos darkBackground e lightBackground só podem ser usados 
    com objetos do tipo Color.

    Os métodos darkBackground e lightBackground são estáticos e retornam objetos 
    do tipo Color com valores específicos de vermelho, verde e azul. 
    Eles podem ser usados como estilos de forma para preencher 
    formas com as cores de fundo escura ou clara, respectivamente.

    Exemplo:

    struct MyView: View {
        var body: some View {
            Circle()
                .fill(Color.darkBackground)
            Rectangle()
                .fill(Color.lightBackground)
        }
    }
*/
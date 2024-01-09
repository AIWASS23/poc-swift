import SwiftUI

/*
Esses métodos são úteis para ajustar o comportamento de layout das visualizações 
no SwiftUI de acordo com os requisitos de alinhamento e tamanho desejados em 
diferentes contextos de interface de usuário.

Text("Hello, SwiftUI!")
    .hLeading() // Alinha à esquerda horizontalmente
    .vCenter() // Centraliza verticalmente
*/

@available(macOS 10.15, *)
extension View {
    func hLeading() -> some View {
        self.frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func hCenter() -> some View {
        self.frame(maxWidth: .infinity, alignment: .center)
    }
    
    func hTrailing() -> some View {
        self.frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    func vTop() -> some View {
        self.frame(maxHeight: .infinity, alignment: .top)
    }
    
    func vCenter() -> some View {
        self.frame(maxHeight: .infinity, alignment: .center)
    }
    
    func vBottom() -> some View {
        self.frame(maxHeight: .infinity, alignment: .bottom)
    }
}

import SwiftUI

struct AdaptiveContainerView<Content: View>: View {
    
    @State private var width:CGFloat = 0
    @State private var height:CGFloat = 0
    
    var content: Content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            Color.clear
            if width > height {
                HStack {
                    content
                }
            } else {
                VStack {
                    content
                }
            }
        }.getSize { size in
            width = size.width
            height = size.height
        }
    }
    
}

/*
    A função getSize aceita um parâmetro chamado onChange, 
    que é uma closure (ou função anônima) que é chamada 
    quando o tamanho da View é alterado. 
    A função getSize retorna um valor do tipo some View, 
    que é um tipo especial no SwiftUI que permite 
    que a função seja usada com qualquer tipo de View.
    Quando a função getSize é chamada, ela adiciona 
    um componente de interface de usuário chamado 
    GeometryReader à View, isso permite obter o tamanho da View atual. 
    A View também adiciona uma ação chamada onPreferenceChange, 
    que é chamada quando o tamanho da View é alterado. 
    Quando essa ação é chamada, a closure onChange é chamada com o novo tamanho da View.
*/

extension View {
    func getSize(onChange: @escaping(CGSize) -> Void) -> some View {
        background(
            GeometryReader{ reader in
                Color.clear
                    .preference(key: SizePrefernceKey.self, value: reader.size)
            }
        )
        .onPreferenceChange(SizePrefernceKey.self, perform: onChange)
    }
}

/*
    O SizePreferenceKey, implementa o protocolo PreferenceKey. 
    A estrutura SizePreferenceKey possui um valor padrão de .zero, 
    ou seja, um tamanho de 0 para largura e altura.
    PreferenceKeys são usados ​​no SwiftUI para armazenar e 
    recuperar valores de preferência que são compartilhados por vários 
    componentes de visualização. Eles são úteis para passar informações 
    entre várias visualizações sem precisar usar estados compartilhados ou binding. 
    Por exemplo, um componente de visualização pode definir o 
    tamanho de uma visualização filha usando uma PreferenceKey e, 
    em seguida, outra visualização pai pode ler esse valor de tamanho e 
    usá-lo para ajustar seu próprio layout.
*/

private struct SizePrefernceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    /*
        O método reduce é usado para combinar vários valores em um único valor. 
        Neste caso, ele não faz nada com o próximo valor fornecido pelo parâmetro nextvalue. 
        Ele simplesmente deixa o valor atual da struct inalterado.

    */

    static func reduce(value: inout CGSize, nextValue nextvalue: () -> CGSize) {}
}

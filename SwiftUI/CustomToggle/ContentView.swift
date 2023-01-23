import SwiftUI

struct ContentView: View {
    @State var isLightMode: Bool = false
    
    var body: some View {

        /*
            "var body: some View" é uma propriedade obrigatória em uma struct ou classe que implementa a 
            protocolo View em SwiftUI. Ele define o conteúdo da interface gráfica que será exibida na tela. 
            É dentro do corpo da propriedade "body" que são adicionados e modificados os elementos da 
            interface do aplicativo, como textos, imagens e outros componentes visuais. A declaração 
            "some View" é usada para indicar que o tipo retornado pelo corpo da propriedade é um tipo 
            específico do protocolo View, mas não precisa ser especificado exatamente qual tipo é esse. 
            Isso é chamado de "tipo opaco" e é usado para ajudar a manter a flexibilidade e o 
            encapsulamento da estrutura de views.
        */

        ZStack {
            background
            
            Toggle("", isOn: $isLightMode.animation(.easeInOut))
                .frame(width: 300, height: 100, alignment: .center)
                .toggleStyle(MyToggleStyle())
        }
        .preferredColorScheme(isLightMode ? .light : .dark)

        /*
            preferredColorScheme é uma propriedade de ambiente em SwiftUI que indica o esquema de cores 
            preferido pelo usuário no dispositivo atual. Ele pode ser usado para adaptar a interface do 
            aplicativo de acordo com o modo de visualização escolhido pelo usuário (claro ou escuro).
        */
    }
    
    @ViewBuilder private var background: some View {

        /*
            @ViewBuilder é uma anotação em SwiftUI que indica que o corpo da função ou propriedade retorna 
            um ou mais objetos do tipo View. Ela permite que o corpo da função ou propriedade use a sintaxe 
            de construção de views de forma mais conveniente e legível, como se estivesse dentro de um 
            corpo de uma view. Ele é usado para construir interfaces gráficas de usuário que são descritas 
            usando composição de vários objetos View.
        */

        if isLightMode {
            Color(uiColor: .white)
                .ignoresSafeArea()
        } else {
            Color(uiColor: .black)
                .ignoresSafeArea()
        }

        /*
            Essa função define a propriedade "background" como um ViewBuilder privado. Dependendo do valor 
            da propriedade "isLightMode", ele retorna uma cor de fundo branca ou preta com o método 
            "ignoresSafeArea()" aplicado. O método "ignoresSafeArea()" fará com que o conteúdo desse view 
            ignore a área segura, ou seja, o conteúdo será desenhado atrás dos elementos de interface da 
            borda superior e inferior, se houver.
        */
    }
}

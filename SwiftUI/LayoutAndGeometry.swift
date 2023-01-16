import SwiftUI

/*
    O CoverFlowContentView, cria uma visualização de rolagem horizontal com uma lista de retângulos 
    coloridos. A lista de cores é definida como uma constante, "colors", com sete cores diferentes. 
    O corpo da struct usa um GeometryReader e um ScrollView para criar uma visualização de rolagem 
    horizontal. Dentro do ScrollView, há um HStack que contém um loop ForEach para criar 50 retângulos. 
    Cada retângulo é preenchido com uma das sete cores da lista "colors", e é rotacionado 3D efeito baseado 
    na posição do retângulo em relação ao centro da visualização. Também é definido o tamanho do retângulo, 
    e o espaçamento horizontal é ajustado para centralizar os retângulos na visualização.
*/

struct CoverFlowContentView: View {
    let colors: [Color] = [.red, .green, .blue, .orange, .pink, .purple, .yellow]

    var body: some View {

        /*
            GeometryReader é um tipo de visualização do SwiftUI que permite acessar informações geométricas 
            sobre a visualização subjacente. Ele fornece acesso a informações como tamanho, posição e 
            transformações de uma visualização, e pode ser usado para criar efeitos de layout avançados ou 
            interações com o usuário. Ao usar um GeometryReader, você pode obter uma instância de 
            GeometryProxy, que contém informações sobre a visualização subjacente. Dentro do GeometryReader, 
            você pode usar essas informações para ajustar o layout ou a aparência de outras visualizações.
            Exemplo:

            GeometryReader { geometry in
                Text("Width: \(geometry.size.width), Height: \(geometry.size.height)")
            }
        */

        GeometryReader { fullView in
            ScrollView(.horizontal, showsIndicators: false) {

                /*
                    showsIndicators é uma propriedade do ScrollView em SwiftUI que determina se os 
                    indicadores de rolagem (scrollbars) são exibidos ou não. Se showsIndicators for true, 
                    os indicadores de rolagem serão exibidos; caso contrário, eles serão ocultos.
                */

                HStack {
                    ForEach(0..<50) { index in
                        GeometryReader { geo in
                            Rectangle()
                                .fill(self.colors[index % 7])
                                .frame(height: 150)
                                .rotation3DEffect(.degrees(-Double(geo.frame(in: .global).midX - fullView.size.width / 2) / 10), axis: (x: 0, y: 1, z: 0))
                        }
                        .frame(width: 150)
                    }
                }
                .padding(.horizontal, (fullView.size.width - 150) / 2)
            }
        }
        .edgesIgnoringSafeArea(.all)

        /*
            .edgesIgnoringSafeArea é um método do SwiftUI que permite ignorar áreas de segurança ao 
            posicionar a visualização. As áreas de segurança são as áreas da tela que podem ser ocultadas 
            por recursos físicos do dispositivo, como a tela do notch (entalhe) no iPhone X. Quando você 
            adiciona .edgesIgnoringSafeArea(.all) a uma visualização, essa visualização é posicionada na 
            borda da tela, ignorando as áreas de segurança. Isso pode ser útil para criar efeitos de 
            layout ou interações que precisam estender para além da área de segurança. Exemplo:

            VStack {
                // Some content
            }
            .edgesIgnoringSafeArea(.all)

            O VStack é posicionado na borda da tela, ignorando as áreas de segurança. Podemos usar:
            .edgesIgnoringSafeArea(.top), 
            .edgesIgnoringSafeArea(.bottom) 
            .edgesIgnoringSafeArea(.leading) 
            .edgesIgnoringSafeArea(.trailing) para ignorar as áreas de segurança apenas em uma dada borda.
        */
    }
}

struct ScrollEffectsContentView: View {
    let colors: [Color] = [.red, .green, .blue, .orange, .pink, .purple, .yellow]

    var body: some View {
        GeometryReader { fullView in
            ScrollView(.vertical) {
                ForEach(0..<50) { index in
                    GeometryReader { geo in
                        Text("Row #\(index)")
                            .font(.title)
                            .frame(width: fullView.size.width)
                            .background(self.colors[index % 7])
                            .rotation3DEffect(.degrees(Double(geo.frame(in: .global).minY - fullView.size.height / 2) / 5), axis: (x: 0, y: 1, z: 0))
                    }
                    .frame(height: 40)
                }
            }
        }
    }
}

struct OuterView: View {
    var body: some View {
        VStack {
            Text("Top")
            InnerView()
                .background(Color.green)
            Text("Bottom")
        }
    }
}

struct InnerView: View {
    var body: some View {
        HStack {
            Text("Left")
            GeometryReader { geo in
                Text("Center")
                    .background(Color.blue)
                    .onTapGesture {
                        print("Global center: \(geo.frame(in: .global).midX) x \(geo.frame(in: .global).midY)")
                        print("Custom center: \(geo.frame(in: .named("Custom")).midX) x \(geo.frame(in: .named("Custom")).midY)")
                        print("Local center: \(geo.frame(in: .local).midX) x \(geo.frame(in: .local).midY)")
                    }
            }
            .background(Color.orange)
            Text("Right")
        }
    }
}

struct CoordinateSpacesContentView: View {
    var body: some View {
        OuterView()
            .background(Color.red)
            .coordinateSpace(name: "Custom")

            /*
                .coordinateSpace é uma propriedade do SwiftUI que permite acessar o espaço de coordenadas 
                de uma visualização. O espaço de coordenadas é o sistema de coordenadas que é usado para 
                posicionar e dimensionar uma visualização dentro da hierarquia de visualizações. Ao acessar 
                o espaço de coordenadas de uma visualização, é possível obter informações sobre sua posição 
                e tamanho, bem como transformá-lo de diferentes maneiras. Exemplo:

                Rectangle()
                    .fill(Color.red)
                    .frame(width: 100, height: 100)
                    .offset(x: 50, y: 50)
                    .coordinateSpace

                O retângulo é preenchido com vermelho, tem um tamanho de 100x100, e tem um offset de 50 em x
                e y. O coordinateSpace permite acessar as propriedades do espaço de coordenadas do retângulo.
                Além disso, o coordinateSpace pode ser usado em conjunto com o GeometryReader, para obter 
                informações sobre como a visualização está sendo exibida em relação a outras visualizações.
            */
    }
}

extension VerticalAlignment { //https://developer.apple.com/documentation/swiftui/verticalalignment/
    struct MidAccountAndName: AlignmentID {  // https://developer.apple.com/documentation/swiftui/alignmentid/
        static func defaultValue(in d: ViewDimensions) -> CGFloat {  // https://developer.apple.com/documentation/swiftui/viewdimensions/
            d[.top]
        }
    }

    static let midAccountAndName = VerticalAlignment(MidAccountAndName.self)
}

struct CustomAlignmentGuideContentView: View {
    var body: some View {
        HStack(alignment: .midAccountAndName) {
            VStack {
                Text("@aiwass47")
                    .alignmentGuide(.midAccountAndName) { d in d[VerticalAlignment.center] }

                    /*
                        alignmentGuide() é um método do SwiftUI que permite definir um ponto de referência 
                        personalizado para alinhar visualizações dentro de um contêiner, como VStack ou 
                        HStack. Ele é usado para especificar um ponto de referência dentro de uma 
                        visualização que será usado para alinhar outras visualizações. O método 
                        .alignmentGuide() é usado dentro de um contêiner, como VStack ou HStack, e é 
                        passado uma closure que define o ponto de referência. A closure é passada uma 
                        instância de ViewDimensions que contém informações sobre as dimensões da 
                        visualização subjacente. Exemplo:

                        VStack(alignment: .center) {
                            Text("Hello")
                            Text("World")
                            .alignmentGuide(.leading) { d in d[.trailing] }
                            Text("!")
                        }
                        O ponto de referência para alinhamento é definido como o ponto de tração do texto 
                        "World". Isso fará com que o texto "!" seja alinhado com o ponto de tração do 
                        texto "World" e, portanto, seja alinhado à esquerda. Nota-se que o método 
                        .alignmentGuide() deve ser aplicado a uma visualização filha dentro do contêiner.
                    */
                Image("")
                    .resizable()
                    .frame(width: 64, height: 64)
            }

            VStack {
                Text("Olé")
                Text("Marcelo")
                    .alignmentGuide(.midAccountAndName) { d in d[VerticalAlignment.center] }
                    .font(.largeTitle)
            }
        }
    }
}

struct SimpleAlignmentGuideContentView: View {
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(0..<10) { position in
                Text("Number \(position)")
                    .alignmentGuide(.leading) { _ in CGFloat(position) * -10 }
            }
        }
        .background(Color.red)
        .frame(width: 400, height: 400)
        .background(Color.blue)
    }
}

struct SimpleAlignmentContentView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Hello, world!")
            Text("This is a longer line of text")
        }
        .background(Color.red)
        .frame(width: 400, height: 400)
        .background(Color.blue)
    }
}

struct ContentView: View {
    var body: some View {
        HStack(alignment: .lastTextBaseline) {
            Text("Live")
                .font(.caption)
            Text("long")
            Text("and")
                .font(.title)
            Text("prosper")
                .font(.largeTitle)
        }
    }
}
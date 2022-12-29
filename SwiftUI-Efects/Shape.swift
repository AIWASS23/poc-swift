import SwiftUI

/*
    A struct Triangle implementa um protocolo chamado 
    Shape (Forma). O protocolo Shape define um único 
    método obrigatório chamado path(in:), 
    que espera um parâmetro de entrada do tipo CGRect e retorna um valor do tipo Path.

    A struct Triangle implementa esse método de forma a desenhar 
    um triângulo dentro de um retângulo dado. O código cria um novo caminho vazio, 
    move o ponto de partida para o ponto central da parte inferior do retângulo, 
    adiciona três linhas que ligam o ponto central às pontas superiores do retângulo e, 
    por fim, retorna o caminho criado.
*/

struct Triangle: Shape {

    func path(in rect: CGRect) -> Path {
        var path = Path()

        /*
            Shape é um protocolo do framework SwiftUI que permite desenhar formas personalizadas 
            usando caminhos. Você pode usar o Shape para criar formas como círculos, elipses, retângulos, 
            linhas ou até mesmo formas complexas como ícones personalizados.

            Precisamos definir uma estrutura ou classe que implemente o protocolo Shape. 
            O protocolo Shape define um único método obrigatório chamado path(in:), 
            que espera um parâmetro de entrada do tipo CGRect e retorna um valor do tipo Path. 
            Você implementa esse método de forma a desenhar a forma que deseja dentro do 
            retângulo fornecido.

            Uma vez que você tenha implementado o método path(in:), 
            pode usar o Shape como qualquer outra vista do SwiftUI, 
            adicionando-a à sua hierarquia de visualização e 
            configurando suas propriedades de estilo e outras propriedades conforme necessário.

            EXEMPLO:

            struct Circle: Shape {
                func path(in rect: CGRect) -> Path {
                    let radius = min(rect.width, rect.height) / 2
                    let center = CGPoint(x: rect.midX, y: rect.midY)
                    return Path(ellipseIn: CGRect(origin: center, size: CGSize(width: radius, height: radius)))
                }
            }
            Para usar a struct Circle, basta adicioná-la à sua hierarquia de visualização:

            Circle()
                .fill(Color.red)
                .frame(width: 200, height: 200)
        */

        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))

        return path
    }
}

/*
    A struct Arc implementa um protocolo chamado InsettableShape (Forma Inserível). 
    O protocolo InsettableShape herda de um protocolo mais genérico chamado Shape (Forma) 
    e adiciona um método opcional chamado inset(by:) 
    que permite inserir uma forma por uma determinada quantidade.
    A struct Arc também implementa o método path(in:) 
    do protocolo Shape.

    A struct Arc define quatro propriedades: startAngle (ângulo de início), 
    endAngle (ângulo final), clockwise (sentido horário) e insetAmount (valor de inserção). 
    Essas propriedades determinam o ângulo de início e fim do arco e se ele será desenhado 
    no sentido horário ou anti-horário, bem como a quantidade de inserção a ser aplicada à forma.

    O método inset(by:) é implementado de forma a aumentar o valor da propriedade 
    insetAmount em um determinado montante. Isso permite que a forma seja inserida por 
    uma determinada quantidade ao chamar esse método.
*/

struct Arc: InsettableShape {

    /*
        InsettableShape é um protocolo do framework SwiftUI que herda de um 
        protocolo mais genérico chamado Shape e adiciona um método opcional chamado 
        inset(by:) que permite inserir uma forma por uma determinada quantidade. 
        O protocolo InsettableShape é útil quando você deseja criar formas que possam ser 
        facilmente inseridas por uma determinada quantidade, como uma forma de círculo com um buraco no meio.

        Para criar uma forma inserível, basta definir uma estrutura ou classe que 
        implemente o protocolo InsettableShape. Além de implementar o método path(in:) 
        do protocolo Shape, você também precisa implementar o método inset(by:) 
        do protocolo InsettableShape. O método inset(by:) deve retornar uma nova instância da 
        sua forma com a inserção aplicada.

        EXEMPLO:

        struct Donut: InsettableShape {
            var insetAmount: CGFloat = 0

            func path(in rect: CGRect) -> Path {
                let center = CGPoint(x: rect.midX, y: rect.midY)
                let outerRadius = rect.width / 2
                let innerRadius = outerRadius - insetAmount

                var path = Path()
                path.move(to: CGPoint(x: center.x + innerRadius, y: center.y))
                path.addArc(center: center, radius: innerRadius, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 360), clockwise: false)
                path.addArc(center: center, radius: outerRadius, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 360), clockwise: false)

                return path
            }

            func inset(by amount: CGFloat) -> some InsettableShape {
                var donut = self
                donut.insetAmount += amount

                return donut
            }
        }

        Para usar a struct Donut, basta adicioná-la à sua hierarquia de visualização:

        Donut()
            .fill(Color.red)
            .frame(width: 200, height: 200)
            .inset(by: 50)

    */

    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool
    var insetAmount = 0.0

    func path(in rect: CGRect) -> Path {
        let rotationAdjustment = Angle.degrees(90)
        let modifiedStart = startAngle - rotationAdjustment
        let modifiedEnd = endAngle - rotationAdjustment

        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2 - insetAmount, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: !clockwise)

        return path
    }

    func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        return arc
    }
}

/*
    A struct Flower define duas propriedades: petalOffset (deslocamento da pétala) e 
    petalWidth (largura da pétala). Essas propriedades determinam a posição e 
    largura das pétalas da flor.

    A struct Flower implementa o método path(in:) do protocolo Shape, 
    que desenha uma flor com oito pétalas dentro de um retângulo dado. 
    O código cria um novo caminho vazio e, em seguida, usa um laço FOR 
    para percorrer um intervalo de ângulos de 0 a 2π (360 graus), 
    em incrementos de π/8 (22,5 graus). 
    
    Para cada ângulo, o código cria uma pétala, a rotaciona para o ângulo especificado, 
    a posiciona no centro do retângulo e a adiciona ao caminho. 
    Por fim, o código retorna o caminho criado.
*/
struct Flower: Shape {
    var petalOffset: Double = -20
    var petalWidth: Double = 100

    func path(in rect: CGRect) -> Path {
        var path = Path()

        /*
            Stride é uma função do Swift que permite iterar por um intervalo de valores 
            com um determinado passo. Ela é especialmente útil quando você quer iterar por 
            um intervalo de números inteiros ou ponto flutuante.

            A sintaxe da função stride é a seguinte:
            stride(from: start, to: end, by: step)

            A função stride espera três parâmetros:
            start: o valor inicial do intervalo.

            end: o valor final do intervalo.

            step: o tamanho do passo a ser usado ao percorrer o intervalo.

            A função stride retorna um intervalo de valores do tipo StrideTo 
            que pode ser usado em um laço for para iterar pelos valores do intervalo.
        */

        for number in stride(from: 0, to: Double.pi * 2, by: Double.pi / 8) {

            /*
                CGAffineTransform é um tipo de dados do framework Core Graphics 
                que representa uma transformação afim, que é uma transformação geométrica 
                que preserva as relações de retas paralelas e de distância entre pontos. 
                As transformações afins incluem operações como translação, rotação, escala e reflexão.

                Podemos usar um objeto CGAffineTransform para aplicar uma 
                transformação afim a um objeto gráfico, como um caminho ou uma imagem. 
                Para criar um objeto CGAffineTransform, podemos usar os iniciadores de classe 
                fornecidos pelo Core Graphics, como por exemplo:

                CGAffineTransform.identity: cria uma transformação afim que não altera o objeto.

                CGAffineTransform(translationX: y:): cria uma transformação afim de translação.

                CGAffineTransform(rotationAngle:): cria uma transformação afim de rotação.

                CGAffineTransform(scaleX: y:): cria uma transformação afim de escala
            */
            let rotation = CGAffineTransform(rotationAngle: number)
            let position = rotation.concatenating(CGAffineTransform(translationX: rect.width / 2, y: rect.height / 2))
            let originalPetal = Path(ellipseIn: CGRect(x: petalOffset, y: 0, width: petalWidth, height: rect.width / 2))
            let rotatedPetal = originalPetal.applying(position)

            path.addPath(rotatedPetal)
        }

        return path
    }
}

struct FlowerContentView: View {
    @State private var petalOffset = -20.0
    @State private var petalWidth = 100.0

    var body: some View {
        VStack {
            Flower(petalOffset: petalOffset, petalWidth: petalWidth)
                .fill(.red, style: FillStyle(eoFill: true))

            Text("Offset")
            Slider(value: $petalOffset, in: -40...40)
                .padding([.horizontal, .bottom])

            Text("Width")
            Slider(value: $petalWidth, in: 0...100)
                .padding(.horizontal)
        }
    }
}

struct ColorCyclingCircle: View {
    var amount = 0.0
    var steps = 100

    var body: some View {
        ZStack {
            ForEach(0..<steps) { value in
                Circle()
                    .inset(by: Double(value))
                    .strokeBorder(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                color(for: value, brightness: 1),
                                color(for: value, brightness: 0.5)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 2
                    )
            }
        }
        .drawingGroup()
        /*
            drawingGroup() é um método do framework SwiftUI que permite agrupar várias visualizações 
            em um único desenho. Ele cria um novo contexto de desenho e desenha todas as visualizações 
            filhas dentro desse contexto. Quando todas as visualizações filhas são desenhadas, 
            o contexto é fechado e o desenho resultante é retornado como uma imagem.

            Podemos usar o método drawingGroup() para agrupar várias visualizações 
            em um único desenho para melhorar o desempenho da sua interface do usuário. 
            Isso é especialmente útil quando você tem muitas visualizações 
            pequenas que são desenhadas juntas, como por exemplo uma grade de células. 
            Ao agrupá-las em um único desenho, você pode evitar o overhead de chamar 
            o método de desenho múltiplas vezes e acelerar o desenho da interface do usuário.
        */
    }

    /*
        A função color que retorna uma instância da estrutura Color com base em um 
        valor inteiro e um valor de brilho. A função color espera dois parâmetros:

        value: o valor inteiro para o qual a cor deve ser gerada.
        brightness: o valor de brilho da cor gerada. O brilho deve ser um valor entre 0 e 1, 
        onde 0 representa o mínimo de brilho e 1 representa o máximo de brilho.

        A função color começa calculando o tom alvo da cor com base no valor 
        fornecido e em uma quantidade fixa (assumindo que a quantidade é uma variável global). 
        Se o tom alvo for maior que 1, ele é subtraído de 1 para garantir que o 
        tom fique dentro do intervalo válido (de 0 a 1). Em seguida, 
        a função retorna uma nova instância da estrutura Color com o tom e o brilho especificados.
    */

    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(steps) + amount

        if targetHue > 1 {
            targetHue -= 1
        }

        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}

struct ColorCyclingCircleContentView: View {
    @State private var colorCycle = 0.0

    var body: some View {
        VStack {
            ColorCyclingCircle(amount: colorCycle)
                .frame(width: 300, height: 300)

            Slider(value: $colorCycle)
        }
    }
}

struct BlendModesContentView: View {
    @State private var amount = 0.0

    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(.red)
                    .frame(width: 200 * amount)
                    .offset(x: -50, y: -80)
                    .blendMode(.screen)

                Circle()
                    .fill(.green)
                    .frame(width: 200 * amount)
                    .offset(x: 50, y: -80)
                    .blendMode(.screen)

                Circle()
                    .fill(.blue)
                    .frame(width: 200 * amount)

                    /*
                        blendMode (modo de mesclagem) é um tipo de dados do framework SwiftUI 
                        que especifica como uma visualização deve ser mesclada com o que já foi 
                        desenhado no contexto de desenho atual. Ele é usado para controlar 
                        como uma visualização interage com o conteúdo de fundo ao ser desenhada.

                        O tipo blendMode é definido pela enumeração BlendMode e 
                        inclui várias opções, como por exemplo:

                        .normal: desenha a visualização sem qualquer mesclagem especial. É o modo padrão.
                        .multiply: multiplica os valores de cor da visualização pelos valores de cor do conteúdo de fundo. Isso resulta em uma cor mais escura.
                        .screen: soma os valores de cor da visualização e do conteúdo de fundo, dividindo o resultado por 1. Isso resulta em uma cor mais clara.
                        .overlay: mistura os valores de cor da visualização e do conteúdo de fundo de acordo com o brilho de cada cor.
                    */

                    .blendMode(.screen)
            }
            .frame(width: 300, height: 300)

            Slider(value: $amount)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
        .ignoresSafeArea()
    }
}

/*
    A struct Trapezoid implementa um protocolo Shape essa struct tem uma propriedade 
    chamada insetAmount (quantidade de encaixe), que determina o quanto o 
    topo do trapézio está inserido. A struct também implementa o protocolo Animatable (Animável), 
    o que significa que a propriedade insetAmount é animável.

    A struct Trapezoid também implementa o método path(in:) do protocolo Shape, 
    que retorna um caminho que representa o trapézio. O caminho é criado movendo-se 
    para o ponto inferior esquerdo do retângulo, 
    adicionando linhas para os outros três vértices do trapézio e, 
    finalmente, adicionando uma linha de volta ao ponto inicial. 
    O tamanho e a forma do trapézio são determinados pelo valor da propriedade insetAmount.
*/
struct Trapezoid: Shape {
    var insetAmount: Double

    var animatableData: Double {
        get { insetAmount }
        set { insetAmount = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: 0, y: rect.maxY))
        path.addLine(to: CGPoint(x: insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))

        return path
   }
}

struct TrapezoidContentView: View {
    @State private var insetAmount = 50.0

    var body: some View {
        Trapezoid(insetAmount: insetAmount)
            .frame(width: 200, height: 100)
            .onTapGesture {
                withAnimation {
                    insetAmount = Double.random(in: 10...90)
                }
            }
    }
}

/*
    A struct Checkerboard implementa um protocolo chamado Shape. A estrutura Checkerboard 
    tem duas propriedades, rows (linhas) e columns (colunas), 
    que determinam o número de linhas e colunas do tabuleiro. 
    A struct também implementa o protocolo Animatable (Animável), 
    o que significa que as propriedades rows e columns são animáveis.

    A struct Checkerboard também implementa o método path(in:) do protocolo Shape, 
    que retorna um caminho que representa a tabuleiro. O caminho é criado iterando pelas linhas e colunas 
    do tabuleiro e adicionando retângulos para os quadrados pretos da quadriculada. 
    O tamanho e a forma da quadriculada são determinados pelos valores das propriedades rows e columns.
*/

struct Checkerboard: Shape {
    var rows: Int
    var columns: Int

    var animatableData: AnimatablePair<Double, Double> {
        get {
           AnimatablePair(Double(rows), Double(columns))
        }

        set {
            rows = Int(newValue.first)
            columns = Int(newValue.second)
        }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let rowSize = rect.height / Double(rows)
        let columnSize = rect.width / Double(columns)

        for row in 0..<rows {
            for column in 0..<columns {
                if (row + column).isMultiple(of: 2) {
                    let startX = columnSize * Double(column)
                    let startY = rowSize * Double(row)

                    let rect = CGRect(x: startX, y: startY, width: columnSize, height: rowSize)
                    path.addRect(rect)
                }
            }
        }

        return path
    }
}
/*
    O Spirograph implementa um protocolo Shape. O Spirograph tem quatro propriedades: 
    innerRadius (raio interno), outerRadius (raio externo), distance (distância) 
    e amount (quantidade). Essas propriedades são usadas para controlar a forma e o tamanho do espigrafo.

    O Spirograph também define uma função chamada 
    gcd (maior divisor comum), que é usada para calcular o maior divisor comum 
    entre dois números inteiros. Essa função é usada para ajudar a determinar o tamanho do espigrafo.

    O Spirograph também implementa o método path(in:) do protocolo Shape, 
    que retorna um caminho que representa o espigrafo. 
    O caminho é criado iterando pelos ângulos do espigrafo e calculando 
    as coordenadas x e y de cada ponto com base nas propriedades 
    innerRadius, outerRadius, distance e amount. 
    Em seguida, o caminho é criado adicionando linhas entre esses pontos.
*/

struct CheckerboardContentView: View {
    @State private var rows = 4
    @State private var columns = 4

    var body: some View {
        Checkerboard(rows: rows, columns: columns)
            .onTapGesture {
                withAnimation(.linear(duration: 3)) {
                    rows = 8
                    columns = 16
                }
            }
    }
}

struct Spirograph: Shape {
    let innerRadius: Int
    let outerRadius: Int
    let distance: Int
    let amount: Double

    func gcd(_ a: Int, _ b: Int) -> Int {
        var a = a
        var b = b

        while b != 0 {
            let temp = b
            b = a % b
            a = temp
        }

        return a
    }

    func path(in rect: CGRect) -> Path {
        let divisor = gcd(innerRadius, outerRadius)
        let outerRadius = Double(self.outerRadius)
        let innerRadius = Double(self.innerRadius)
        let distance = Double(self.distance)
        let difference = innerRadius - outerRadius

        /*
            ceil (teto) é uma função matemática do Swift que arredonda um número 
            para o inteiro imediatamente maior. Por exemplo, se você chamar ceil 
            com um número como 2.3, ele retornará 3. Se você chamar ceil com um 
            número como 4.9, ele também retornará 5.

            A função ceil é útil quando você precisa arredondar um número para 
            cima para o inteiro mais próximo, independentemente de ser maior ou menor. 
        */
        let endPoint = ceil(2 * Double.pi * outerRadius / Double(divisor)) * amount

        var path = Path()

        for theta in stride(from: 0, through: endPoint, by: 0.01) {
            var x = difference * cos(theta) + distance * cos(difference / outerRadius * theta)
            var y = difference * sin(theta) - distance * sin(difference / outerRadius * theta)

            x += rect.width / 2
            y += rect.height / 2

            if theta == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }

        return path

    }
}

struct ContentView: View {
    @State private var innerRadius = 125.0
    @State private var outerRadius = 75.0
    @State private var distance = 25.0
    @State private var amount = 1.0
    @State private var hue = 0.6

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            Spirograph(innerRadius: Int(innerRadius), outerRadius: Int(outerRadius), distance: Int(distance), amount: amount)
                .stroke(Color(hue: hue, saturation: 1, brightness: 1), lineWidth: 1)
                .frame(width: 300, height: 300)

            Spacer()

            Group {
                Text("Inner radius: \(Int(innerRadius))")
                Slider(value: $innerRadius, in: 10...150, step: 1)
                    .padding([.horizontal, .bottom])

                Text("Outer radius: \(Int(outerRadius))")
                Slider(value: $outerRadius, in: 10...150, step: 1)
                    .padding([.horizontal, .bottom])

                Text("Distance: \(Int(distance))")
                Slider(value: $distance, in: 1...150, step: 1)
                    .padding([.horizontal, .bottom])

                Text("Amount: \(amount, format: .number.precision(.fractionLength(2)))")
                Slider(value: $amount)
                    .padding([.horizontal, .bottom])

                Text("Color")
                Slider(value: $hue)
                    .padding(.horizontal)
            }
        }
    }
}

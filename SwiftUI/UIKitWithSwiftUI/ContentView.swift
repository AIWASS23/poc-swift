import SwiftUI

struct MottoView: View {
    let motto1 = Text("Draco dormiens")
    let motto2 = Text("nunquam titillandus")

    var body: some View {
        VStack {
            VStack {
                motto1
                    .foregroundColor(.red)
                motto2
                    .foregroundColor(.blue)
            }
        }
    }
}

struct CapsuleText: View {
    var text: String

    /*
        O Swift silenciosamente aplica um atributo especial à body chamado de @ViewBuilder. 
        Isso tem o efeito de agrupar silenciosamente várias exibições de modo que, 
        mesmo que pareça que estamos enviando de volta várias exibições, elas são combinadas em uma TupleView.
    */

    var body: some View {

        /*
            O SwiftUI depende muito de um recurso avançado do Swift chamado 
            “opaque return types”, que você pode ver em ação 
            toda vez que escreve arquivos some View. 
            Isso significa “um objeto que está em conformidade com o View protocolo, 
            mas não queremos dizer o que é.
            Return some View significa que, embora não saibamos qual tipo de exibição está retornando, 
            o compilador sabe. Em primeiro lugar, o uso some View é importante para o desempenho: 
            o SwiftUI precisa ser capaz de ver as visualizações que estamos mostrando 
            e entender como elas mudam, para que possa atualizar corretamente 
            a interface do usuário. Se o SwiftUI não tivesse essas informações extras, 
            seria muito lento para o SwiftUI descobrir exatamente o que mudou, 
            seria necessário abandonar tudo e começar de novo após cada pequena alteração.
        */

        Text(text)
            .font(.largeTitle)
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .clipShape(Capsule())
    }
}

/*
    Para criar um modificador customizado, 
    crie uma nova estrutura que esteja em conformidade com o View Modifier protocolo. 
    Isso tem apenas um requisito, que é um método chamado body que aceita qualquer conteúdo 
    que esteja sendo fornecido para trabalhar e deve retornar some View.
*/

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

/*
    Modificadores customizados, geralmente é uma boa ideia criar extensões View 
    que os tornem mais fáceis de usar.
*/

extension View {
    func titleStyle() -> some View {

        /*
            O modifier() nos permite aplicar qualquer tipo de modificador customizado  a uma view.
        */

        self.modifier(Title())
    }
}

/*
    Usando o modificador:
    Text("Hello World")
        .titleStyle()
*/

struct Watermark: ViewModifier {
    var text: String

    func body(content: Content) -> some View {
        ZStack(alignment: .bottomTrailing) {
            content
            Text(text)
                .font(.caption)
                .foregroundColor(.white)
                .padding(5)
                .background(Color.black)
        }
    }
}

/*
    Os modificadores customizados podem criar uma nova estrutura de exibição. 
    Retornando novos objetos em vez de modificar os existentes.
*/

extension View {
    func watermarked(with text: String) -> some View {
        self.modifier(Watermark(text: text))
    }
}

/*
    Exemplo:
    Color.blue
        .frame(width: 300, height: 200)
        .watermarked(with: "Marcelo")
*/

struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content

    init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.rows = rows
        self.columns = columns
        self.content = content
    }

    var body: some View {
        VStack {
            ForEach(0..<rows, id: \.self) { row in
                HStack {
                    ForEach(0..<self.columns, id: \.self) { column in
                        self.content(row, column)
                    }
                }
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello World")
                .padding()
                .background(Color.red)
                .padding()
                .background(Color.blue)
                .padding()
                .background(Color.green)
                .padding()
                .background(Color.yellow)

            Button("Hello World") {
                print(type(of: self.body))
            }
            .frame(width: 200, height: 200)
            .background(Color.red)

            VStack(spacing: 10) {
                CapsuleText(text: "First")
                    .foregroundColor(.white)
                CapsuleText(text: "Second")
                    .foregroundColor(.yellow)
            }

            GridStack(rows: 4, columns: 4) { row, col in
                Image(systemName: "\(row * 4 + col).circle")
                Text("R\(row) C\(col)")
            }
        }
    }
}

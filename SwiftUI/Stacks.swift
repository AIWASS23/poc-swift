import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""

    @State private var countries = [
        "Estonia", 
        "France", 
        "Germany", 
        "Ireland", 
        "Italy", 
        "Nigeria", 
        "Poland", 
        "Russia", 
        "Spain", 
        "UK", 
        "US"].shuffled() // O shuffled() se encarrega automaticamente de randomizar a ordem do array.
    @State private var correctAnswer = Int.random(in: 0...2)

    var body: some View {

        /*
            VStack pilha vertical de organização de elementos de interface
            HStack pilha horizontal de organização de elementos de interface
            ZStack pilha de profundidade de organização de elementos de interface
        */

        ZStack {

            /*
                O SwiftUI nos dá três tipos de gradientes para trabalhar e, como as cores, 
                também são visualizações que podem ser desenhadas em nossa interface do usuário.
                Os gradientes são compostos de vários componentes:
                Uma variedade de cores para mostrar
                Informações de tamanho e direção
                O tipo de gradiente a ser usado: Radial, Linear e Angular
            */

            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)

                /*
                    .ignoresSafeArea() é um modificador para especificar quais bordas da tela 
                    deseja executar ou não especificar nada para ir automaticamente de ponta a ponta
                */

                .ignoresSafeArea()

            VStack {
                Spacer()

                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)

                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))

                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }

                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {

                            /*
                                O SwiftUI tem um IMAGE tipo dedicado para lidar com imagens em seus aplicativos, 
                                e há três maneiras principais de criá-las:

                                Image("pencil"): Irá carregar uma imagem chamada “Pencil” que você adicionou ao seu projeto.

                                Image(decorative: "pencil"): Carregará a mesma imagem, mas não a lerá para os usuários que ativaram 
                                o leitor de tela. Isso é útil para imagens que não transmitem informações importantes adicionais.

                                Image(systemName: "pencil"): Carregará o ícone de lápis embutido no iOS. 
                                Isso usa a coleção de ícones SF Symbols da Apple.
                            */

                            Image(countries[number])

                                /*
                                    O renderingMode(.original)forçar o SwiftUI a mostrar a imagem original 
                                    em vez da versão recolorida.
                                */

                                .renderingMode(.original)
                                .clipShape(Capsule()) // Torna nossa imagem em forma de cápsula.
                                .shadow(radius: 5) // Aplica um efeito de sombra ao redor
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))

                Spacer()
                Spacer()

                Text("Score: ???")
                    .foregroundColor(.white)
                    .font(.title.bold())

                Spacer()
            }
            .padding()
        }

        /*
            O alert() é usado em tudo o que estamos fazendo é dizer que existe um alerta.
        */

        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is ???")
        }
    }

    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
        } else {
            scoreTitle = "Wrong"
        }

        showingScore = true
    }

    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

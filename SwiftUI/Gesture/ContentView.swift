import SwiftUI

/*
    A aplicação mostra cartões de perguntas e respostas. Ele mostra uma tela principal com uma imagem de 
    fundo, um contador de tempo regressivo e um botão para iniciar novamente. O usuário pode deslizar para 
    cima ou para baixo para ver as perguntas e respostas e pode marcar seu cartão como correto ou incorreto. 
    Há também uma funcionalidade para adicionar novos cartões, e a aplicação é acessível para pessoas com 
    deficiência visual.
*/

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(x: 0, y: offset * 10)
    }
}

/*
    A extensão adiciona uma nova função chamada "stacked" que, quando chamada, desloca a visualização 
    original para cima ou para baixo, baseado na posição fornecida. O parâmetro "position" é a posição 
    atual do elemento e o parâmetro "total" é o número total de elementos. O offset é calculado como 
    (total - position) * 10 e é usado para mover a visualização na direção y. Isso é usado para apresentar 
    uma pilha de cartões, onde cada cartão é deslocado verticalmente para cima ou para baixo, com base na 
    sua posição na pilha.
*/

struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled

    // https://developer.apple.com/documentation/swiftui/environmentvalues

    @State private var cards = [Card]()

    @State private var timeRemaining = 100

    /*
        O Timer é uma classe no SwiftUI que permite que você execute uma ação em intervalos regulares. 
        Ele é usado para criar timers que atualizam regularmente o estado da aplicação, como um contador 
        de tempo regressivo. Podemos criar um timer usando o método Timer.publish(every:on:in:). 
        Ele tem três parâmetros:

        every: o intervalo de tempo entre as chamadas
        on: o RunLoop em que o timer será executado.
        in: o RunLoop.Mode em que o timer será executado.

        Exemplo:

        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

        Esse exemplo cria um timer que é chamado a cada segundo, rodando no RunLoop principal e no modo 
        comum. Você pode usar o timer para atualizar o estado da aplicação, por exemplo, você pode usar o 
        timer para atualizar o valor de um contador de tempo.

        @State private var timeRemaining = 100
        let timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                }
            }
        É importante notar que, quando o timer for criado, ele precisará ser cancelado manualmente quando 
        não for mais necessário. Isto pode ser feito chamando o método invalidate() no objeto timer.
    */

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @Environment(\.scenePhase) var scenePhase
    @State private var isActive = true

    @State private var showingEditScreen = false

    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()

            VStack {
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())

                ZStack {
                    ForEach(0..<cards.count, id: \.self) { index in
                        CardView(card: cards[index]) {
                            withAnimation {
                                removeCard(at: index)
                            }
                        }
                        .stacked(at: index, in: cards.count)
                        .allowsHitTesting(index == cards.count - 1)

                        /*
                            .allowsHitTesting é um modificador de visualização do SwiftUI que indica se uma 
                            visualização pode ser pressionada ou clicada. Se o valor for verdadeiro, a 
                            visualização será clicável e seus eventos de toque serão entregues a ela. Se o 
                            valor for falso, a visualização será "transparente" para eventos de toque e os 
                            eventos serão entregues à visualização subjacente. Você pode usar 
                            .allowsHitTesting para desativar a interação com um botão enquanto aguarda a 
                            conclusão de uma tarefa:

                            Button(action: {
                                // ação
                            }){
                                Text("Press me")
                            }
                            .disabled(isLoading)
                            .allowsHitTesting(!isLoading)

                            De forma similar, você pode usar esse modificador para desativar a interação 
                            com uma visualização específica enquanto aguarda a conclusão de uma tarefa:

                            Image("example")
                                .allowsHitTesting(false)

                            Desta forma, a visualização da imagem não será clicável e os eventos de toque 
                            serão entregues à visualização subjacente.
                        */

                        .accessibilityHidden(index < cards.count - 1)
                    }
                }
                .allowsHitTesting(timeRemaining > 0)

                if cards.isEmpty {
                    Button("Start Again", action: resetCards)
                        .padding()
                        .background(.white)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
            }

            VStack {
                HStack {
                    Spacer()

                    Button {
                        showingEditScreen = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                }

                Spacer()
            }
            .foregroundColor(.white)
            .font(.largeTitle)
            .padding()

            if differentiateWithoutColor || voiceOverEnabled {
                VStack {
                    Spacer()

                    HStack {
                        Button {
                            withAnimation {
                                removeCard(at: cards.count - 1)
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer as being incorrect")

                        Spacer()

                        Button {
                            withAnimation {
                                removeCard(at: cards.count - 1)
                            }
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark your answer is being correct.")
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        .onReceive(timer) { time in
            guard isActive else { return }

            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }

        /*
            .onReceive é um modificador de visualização do SwiftUI que permite que você execute um bloco de 
            código quando um determinado publisher emite um evento. Ele é geralmente usado para reagir a 
            mudanças em publishers de sistema, como notificações de mudanças de orientação, alterações no 
            teclado, modificações em valores de estado, entre outros.

            .onReceive é uma maneira flexível de reagir a mudanças no sistema ou no estado da aplicação e 
            atualizar sua interface de usuário de acordo. É uma alternativa ao uso de "ObservableObject" ou 
            "ObservedObject" e "@State" juntos.
        */

        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                if cards.isEmpty == false {
                    isActive = true
                }
            } else {
                isActive = false
            }
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: resetCards, content: EditCards.init)
        .onAppear(perform: resetCards)
    }

    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                cards = decoded
            }
        }
    }

    func removeCard(at index: Int) {
        guard index >= 0 else { return }

        cards.remove(at: index)

        if cards.isEmpty {
            isActive = false
        }
    }

    func resetCards() {
        timeRemaining = 100
        isActive = true
        loadData()
    }
}
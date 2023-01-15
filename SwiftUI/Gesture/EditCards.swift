import SwiftUI

/*
    Este script define uma struct EditCards que é usada para criar uma interface para editar e gerenciar 
    cartões. A interface consiste em dois campos de texto para adicionar novos cartões e uma lista de 
    cartões existentes. O usuário pode adicionar novos cartões digitando um prompt e uma resposta nos 
    campos de texto e pressionando o botão "Adicionar cartão". O usuário também pode excluir cartões 
    existentes, deslizando-os para a esquerda e tocando em "Excluir". A interface também tem um botão 
    "Feito" que permite que o usuário saia do modo de edição e volte para a tela anterior. Os cartões são 
    armazenados no armazenamento local do dispositivo e carregados quando a visualização é exibida, 
    permitindo que os cartões sejam salvos e carregados entre as sessões.
*/

struct EditCards: View {
    @Environment(\.dismiss) var dismiss
    @State private var cards = [Card]()
    @State private var newPrompt = ""
    @State private var newAnswer = ""

    var body: some View {
        NavigationView {
            List {
                Section("Add new card") {
                    TextField("Prompt", text: $newPrompt)
                    TextField("Answer", text: $newAnswer)
                    Button("Add card", action: addCard)
                }

                Section {
                    ForEach(0..<cards.count, id: \.self) { index in
                        VStack(alignment: .leading) {
                            Text(cards[index].prompt)
                                .font(.headline)

                            Text(cards[index].answer)
                                .foregroundColor(.secondary)
                        }
                    }
                    .onDelete(perform: removeCards)

                    /*
                        .onDelete é um método do SwiftUI que é usado para detectar exclusões em elementos 
                        de lista. Ele é geralmente usado em conjunto com o ForEach para detectar quando um 
                        elemento específico de uma lista é excluído. Ele é ativado quando o usuário desliza 
                        um item para a esquerda e toca em "Excluir" (ou outro botão similar). Ele é 
                        geralmente usado para remover o item excluído de uma fonte de dados, como um array 
                        ou uma lista. A sintaxe para usar o .onDelete é a seguinte:

                        ForEach(data) { item in
                            Text(item.name)
                        }.onDelete { indexSet in
                            // perform delete action
                        }
                    */
                }
            }
            .navigationTitle("Edit Cards")
            .toolbar {
                Button("Done", action: done)
            }

            /*
                .toolbar é um modificador do SwiftUI que adiciona uma barra de ferramentas a uma 
                visualização. Ele é geralmente usado em conjunto com o NavigationView para adicionar botões 
                de ação à barra de ferramentas. A barra de ferramentas é exibida na parte superior da tela 
                e contém botões com ações comuns, como "Salvar", "Cancelar" ou "Feito". A sintaxe para 
                adicionar uma barra de ferramentas a uma visualização é a seguinte:

                NavigationView {
                    // content
                }.toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        // leading items
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        // trailing items
                    }
                }

                É importante mencionar que a barra de ferramentas só é mostrada quando a visualização está 
                dentro de um NavigationView.
            */

            .listStyle(.grouped)
            .onAppear(perform: loadData)
        }
    }

    func done() {
        dismiss()
    }

    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                cards = decoded
            }
        }
    }

    func saveData() {
        if let data = try? JSONEncoder().encode(cards) {
            UserDefaults.standard.set(data, forKey: "Cards")
        }
    }

    func addCard() {
        let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespaces)
        let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)

        /*
            trimmingCharacters é um método do Swift que é usado para remover espaços em branco no início e 
            no final de uma string. Ele recebe como parâmetro um conjunto de caracteres, que podem ser 
            espaços em branco, novos caracteres de linha, tabulações, entre outros. Este método retorna uma 
            nova string sem esses caracteres no início e no final. A sintaxe geral para usar 
            .trimmingCharacters é a seguinte:

            let originalString = "  Hello  "
            let trimmedString = originalString.trimmingCharacters(in: .whitespaces)

            Neste exemplo, a string " Hello " é convertida em "Hello"

            .trimmingCharacters pode ser usado para limpar uma string antes de usá-la, garantindo que não 
            haja espaços em branco desnecessários no início ou no final.
        */
        guard trimmedPrompt.isEmpty == false && trimmedAnswer.isEmpty == false else { return }

        let card = Card(prompt: trimmedPrompt, answer: trimmedAnswer)
        cards.insert(card, at: 0)
        saveData()
    }

    func removeCards(at offsets: IndexSet) {
        cards.remove(atOffsets: offsets)
        saveData()
    }
}
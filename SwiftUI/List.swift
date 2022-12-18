import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""

    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false

    var body: some View {
        NavigationView {
            /*
                O List fornece uma tabela de rolagem de dados e 
                usado para apresentação de dados 
                O listStyle() ajusta a aparência da lista
                
            */
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .autocapitalization(.none) // desabilita a capitalização do campo de texto.
                }

                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord) // onSubmit() precisa receber uma função que não aceite parâmetros e não retorne nada
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }

    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) // O trimmingCharacters(in:) remove certos tipos de caracteres do início e do fim de uma string.
        guard answer.count > 0 else { return }

        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original!")
            return
        }

        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }

        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }

        withAnimation {
            usedWords.insert(answer, at: 0)
        }

        newWord = ""
    }

    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                
                /*
                    O components(separatedBy:)converte uma única string 
                    em uma matriz de strings, quebrando onde vc.
                */

                let allWords = startWords.components(separatedBy: "\n")

                /*
                    O randomElement() retorna um item aleatório do array.
                */

                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }

        fatalError("Could not load start.txt from bundle.")
    }

    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }

    func isPossible(word: String) -> Bool {
        var tempWord = rootWord

        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }

        return true
    }

    func isReal(word: String) -> Bool {
        let checker = UITextChecker() // O UITextChecker() verifica se há palavras com erros ortográficos.
        let range = NSRange(location: 0, length: word.utf16.count) // O NSRange() cria um intervalo de strings reconhecivel pelo Objective-C usando todo o comprimento utf16
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en") // Envia de volta outro intervalo de string no estilo Objective-C, informando onde o erro ortográfico foi encontrado. 

        return misspelledRange.location == NSNotFound // Se o intervalo Objective-C volta como vazio já que o Objective-C não tem opcional 
    }

    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

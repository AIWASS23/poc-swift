import UIKit

/*
    Esse script é um jogo de palavras embaralhadas, o jogo exibe uma palavra aleatória na tela e o jogador 
    deve digitar palavras a partir dessa palavra inicial. A cada palavra corretamente digitada, ela é 
    adicionada a uma tabela na tela e o jogador pode continuar adicionando palavras. O script verifica se a 
    palavra digitada é possível a partir da palavra inicial, se a palavra já foi usada anteriormente e se a 
    palavra é uma palavra válida de acordo com o dicionário inglês.
*/

class ViewController: UITableViewController {
	var allWords = [String]()
	var usedWords = [String]()

	override func viewDidLoad() {
		super.viewDidLoad()

		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))

		if let startWordsPath = Bundle.main.path(forResource: "start", ofType: "txt") {

            /*
                Bundle.main.path é uma função que é usada para recuperar o caminho de arquivos em um pacote 
                de aplicativo. Ele é usado para recuperar recursos incluídos no pacote do aplicativo, como 
                arquivos de imagem, música, vídeo e arquivos de dados. A função Bundle.main.path
                (forResource:ofType:) aceita dois parâmetros, o nome do recurso (resource name) e o tipo do 
                recurso (resource type) e retorna um caminho para o arquivo correspondente se ele existir. 
                Se o arquivo não for encontrado, a função retorna nil.
            */

			if let startWords = try? String(contentsOfFile: startWordsPath) {
				allWords = startWords.components(separatedBy: "\n")

                /*
                    String(contentsOfFile:) é uma função da classe String do Swift que é usada para ler o 
                    conteúdo de um arquivo de texto como uma string. Ela aceita um parâmetro, que é o 
                    caminho do arquivo a ser lido. A função retorna uma nova string com o conteúdo do 
                    arquivo. Caso o arquivo não possa ser lido (por exemplo, se o caminho for inválido ou 
                    se o arquivo não existir), a função lança uma exceção. Esse comando é usado para ler o 
                    arquivo "start.txt" e armazenar as palavras nele em uma array allWords. Além de 
                    String(contentsOfFile:) existem:
                    String(contentsOf: URL),
                    String(contentsOf: URL, encoding: String.Encoding)
                    String(contentsOf: URL, usedEncoding: inout String.Encoding?) 
                    que fazem o mesmo trabalho, mas aceitam outros tipos de parâmetros.
                */
			}
		} else {
			allWords = ["silkworm"]
		}

		startGame()
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return usedWords.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
		cell.textLabel?.text = usedWords[indexPath.row]
		return cell
	}

	func startGame() {
		title = allWords.randomElement()
		usedWords.removeAll(keepingCapacity: true)

        /*
            removeAll(keepingCapacity:) é um método da classe Array do Swift que é usado para remover todos 
            os elementos de um array. Ele aceita um parâmetro opcional, keepingCapacity, que indica se o 
            array deve manter sua capacidade atual (capacidade máxima de elementos que o array pode 
            armazenar sem precisar alocar novamente) ou se ele deve liberar essa capacidade. Quando o 
            parâmetro keepingCapacity é definido como true, o array mantém sua capacidade atual e pode ser 
            preenchido novamente com novos elementos sem precisar alocar novamente. Isso é útil quando você 
            sabe que o array será preenchido novamente com elementos em breve. Quando o parâmetro 
            keepingCapacity é definido como false (o valor padrão), o array libera sua capacidade e pode 
            economizar memória. Isso é útil quando você sabe que o array não será preenchido novamente 
            com elementos em breve.
        */

		tableView.reloadData()
	}

	@objc func promptForAnswer() {
		let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
		ac.addTextField()

		let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned self, ac] action in
			let answer = ac.textFields![0]
			self.submit(answer: answer.text!)

            /*
                A diferença entre [weak self] e [unowned self] no Swift é como eles lidam com a referência 
                ao objeto "self" (que é o objeto atual da classe) dentro de uma clausura (como um block ou 
                uma função anônima).

                [weak self] é usado para criar uma referência fraca (weak reference) ao objeto "self". Isso 
                significa que a clausura não impede que o objeto seja liberado pelo gerenciador de memória 
                (ARC) e que o objeto "self" pode ser nil. Isso é especialmente útil em casos de código que 
                pode causar um vazamento de memória se uma referência forte for mantida.

                [unowned self] é usado para criar uma referência não-forte (unowned reference) ao objeto 
                "self". Isso significa que a clausura não mantém uma referência forte para o objeto "self" 
                e que o objeto "self" nunca será nil. Isso é especialmente útil em casos em que você sabe 
                que o objeto "self" sempre será válido enquanto a clausura estiver sendo executada.

                Em resumo, weak é usado quando o objeto pode ser nulo, e unowned é usado quando o objeto 
                nunca será nulo.

                Para criar uma referência forte (strong reference) a um objeto no Swift, você simplesmente 
                atribui uma referência ao objeto a uma propriedade, constante (let) ou variável (var). 
                Isso cria uma referência forte ao objeto e impede que ele seja liberado pelo gerenciador 
                de memória (ARC).

                É importante notar que, cada vez que você cria uma referência forte para um objeto, você 
                deve garantir que essa referência será liberada quando não for mais necessária para evitar 
                vazamentos de memória. No caso de classes, o gerenciamento de memória é feito pelo ARC, que 
                libera os objetos quando não há mais referências fortes para eles.
            */
		}

		ac.addAction(submitAction)

		present(ac, animated: true)
	}

	func isPossible(word: String) -> Bool {
		var tempWord = title!.lowercased()

		for letter in word {
			if let pos = tempWord.range(of: String(letter)) {
				tempWord.remove(at: pos.lowerBound)
			} else {
				return false
			}
		}

		return true
	}

	func isOriginal(word: String) -> Bool {
		return !usedWords.contains(word)
	}

	func isReal(word: String) -> Bool {
		let checker = UITextChecker()
		let range = NSMakeRange(0, word.utf16.count)
		let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

		return misspelledRange.location == NSNotFound

        /*
            UITextChecker() é uma classe do UIKit que é usada para verificar a ortografia de uma string. 
            Ela oferece métodos para verificar se uma palavra está escrita corretamente, sugerir palavras 
            corretivas para uma palavra incorretamente escrita, e identificar as palavras incorretamente 
            escritas em um texto. A classe UITextChecker é uma classe de nível de sistema e não precisa ser 
            inicializada. Na função ela é usado para verificar se a palavra digitada pelo jogador é uma 
            palavra válida de acordo com o dicionário inglês. 
            O método rangeOfMisspelledWord(in:range:startingAt:wrap:language:) é usado para verificar se 
            há alguma palavra incorretamente escrita na string. Ele retorna uma struct NSRange contendo a 
            posição e o tamanho da palavra incorretamente escrita. Se não houver palavra incorretamente 
            escrita, o método retorna NSNotFound.
        */
	}

	func submit(answer: String) {
		let lowerAnswer = answer.lowercased()

		let errorTitle: String
		let errorMessage: String

		if isPossible(word: lowerAnswer) {
			if isOriginal(word: lowerAnswer) {
				if isReal(word: lowerAnswer) {
					usedWords.insert(answer, at: 0)

					let indexPath = IndexPath(row: 0, section: 0)
					tableView.insertRows(at: [indexPath], with: .automatic)

					return
				} else {
					errorTitle = "Word not recognised"
					errorMessage = "You can't just make them up, you know!"
				}
			} else {
				errorTitle = "Word used already"
				errorMessage = "Be more original!"
			}
		} else {
			errorTitle = "Word not possible"
			errorMessage = "You can't spell that word from '\(title!.lowercased())'!"
		}

		let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "OK", style: .default))
		present(ac, animated: true)
	}
}

import UIKit

class ViewController: UITableViewController {
	var petitions = [Petition]()

	override func viewDidLoad() {
		super.viewDidLoad()

		let urlString: String

		if navigationController?.tabBarItem.tag == 0 {

            /*
                Esse código acessa a propriedade tag do objeto tabBarItem que está associado ao objeto 
                navigationController. O navigationController é um objeto que gerencia a navegação entre 
                telas em uma aplicação iOS. Ele geralmente contém uma pilha de telas e permite que o 
                usuário navegue para trás e para frente entre elas. A tabBarItem é um objeto que representa 
                um item de uma barra de guias. Ele geralmente contém informações como o título e a imagem 
                do item, bem como um rótulo e uma tag. A propriedade tag é um inteiro que pode ser usado 
                para identificar um item de barra de guias de maneira única. Ele pode ser usado para 
                armazenar informações adicionais sobre o item, como qual é a tela associada a ele ou qual é 
                o seu comportamento. Então esse código verifica o objeto tabBarItem associado ao objeto 
                NavigationController e pega o valor da propriedade tag.
            */

			urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
		} else {
			urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
		}

       if let url = URL(string: urlString) {
           if let data = try? Data(contentsOf: url) {
               parse(json: data)
               return
           }

           /*
                Isso tenta criar uma instância de URL a partir de uma string passada como parâmetro chamada 
                "urlString". Se não é possível criar a instância do URL (por exemplo, se a string passada 
                for inválida), a execução do código é interrompida e a instrução "if let url" não é 
                executada. Dentro do segundo "if", ele tenta criar uma instância de Data a partir do 
                conteúdo localizado no URL. Se essa operação falhar (por exemplo, se o arquivo não puder 
                ser encontrado ou se houver problemas de rede), a instrução "if let data" não será 
                executada e o fluxo de execução continuará. Dentro do segundo "if", o método parse(json:) 
                é chamado e passa o dado como parâmetro. Ao final do segundo "if", a instrução "return" é 
                executada, interrompendo a execução do código após a chamada do método parse. Esse código 
                tenta fazer o download de um arquivo a partir de uma URL fornecida e, se for bem-sucedido, 
                passa o conteúdo desse arquivo para o método parse para que ele possa ser processado. 
                Se algum erro ocorrer (como uma URL inválida ou problemas de rede), o código não fará 
                nada e continuará a executar.
           */
       }
        showError()
	}

    func parse(json: Data) {
        let decoder = JSONDecoder()

        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return petitions.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

		let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body

		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let vc = DetailViewController()
		vc.detailItem = petitions[indexPath.row]
		navigationController?.pushViewController(vc, animated: true)
	}

	func showError() {
		let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "OK", style: .default))
		present(ac, animated: true)
	}
}


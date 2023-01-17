import UIKit

class ViewController: UITableViewController {

    /*
        UITableViewController é uma classe do framework UIKit do iOS que é usada para exibir e gerenciar 
        tabelas. Ele é um controlador de visualização especializado que fornece uma interface fácil de usar 
        para trabalhar com tabelas de dados. Ele herda de UIViewController e implementa os protocolos 
        UITableViewDelegate e UITableViewDataSource, que fornecem métodos para gerenciar o conteúdo e o 
        comportamento da tabela. Com UITableViewController, você pode facilmente criar tabelas com vários 
        estilos, como tabelas simples, tabelas com cabeçalhos e rodapés, tabelas com seções e muito mais. 
        Ele também fornece suporte para operações comuns de tabela, como inserção, exclusão e reordenação 
        de células. Além disso, UITableViewController é usado para exibir uma lista de opções, como uma 
        lista de contatos, um histórico de navegação, etc. Ele também pode ser usado para criar menus, 
        como menus de configurações e menus de ajuda.
    */

	var pictures = [String]()

	override func viewDidLoad() {

        /*
            override é uma palavra-chave em Swift que é usada para indicar que uma função ou propriedade 
            está sendo sobreposta em uma subclasse. Ele é usado para substituir o comportamento ou a 
            implementação de uma função ou propriedade herdada de uma superclasse.

            viewDidLoad() é um método presente na classe UIViewController do framework UIKit do iOS que é 
            chamado quando a visualização do controlador é carregada na memória. Ele é geralmente usado 
            para configurar a interface do usuário, carregar dados e fazer qualquer outra configuração 
            inicial que seja necessária antes de exibir a tela para o usuário. Esse método é chamado apenas 
            uma vez durante a vida útil do controlador de visualização, logo após a sua carga na memória. 
            Ele é chamado antes de viewWillAppear(_:) e é geralmente usado para configurar a interface do 
            usuário, carregar dados e fazer outras configurações iniciais que são necessárias antes de 
            exibir a tela para o usuário.

            Ao usar a palavra-chave "super" antes de chamar uma função ou propriedade, você está acessando 
            a implementação original daquela função ou propriedade na superclasse, em vez de chamar a 
            implementação sobreposta na subclasse. Isso é útil quando você deseja chamar a implementação 
            original de uma função ou propriedade, mas também deseja adicionar funcionalidade adicional 
            na subclasse.
        */
		super.viewDidLoad()

		title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true

        /*
            a propriedade prefersLargeTitles da barra de navegação de um objeto UINavigationController 
            para true. Essa propriedade determina se a barra de navegação deve usar títulos grandes para os 
            controladores de visualização na pilha de navegação. Quando prefersLargeTitles é definido como 
            true, o título do controlador de visualização atual é exibido em tamanho grande na barra de 
            navegação. Isso é comum em aplicativos iOS 11 ou superior, onde os títulos grandes são usados 
            para melhorar a legibilidade e chamar a atenção do usuário para o título do controlador de 
            visualização atual.
        */

		let fm = FileManager.default
		let path = Bundle.main.resourcePath!
		let items = try! fm.contentsOfDirectory(atPath: path)

		for item in items {
			if item.hasPrefix("nssl") {
				pictures.append(item)
			}
		}
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return pictures.count

        /*
            Essa função é um método da classe UITableViewDataSource que é chamado pelo objeto 
            UITableView para determinar o número de linhas (células) a serem exibidas em uma seção 
            específica. Ele é usado para informar ao UITableView quantas linhas devem ser exibidas na 
            tabela. A função tem dois parâmetros:

            tableView é uma referência para o objeto UITableView que está solicitando o número de linhas.

            section é o índice da seção para a qual o número de linhas está sendo solicitado.

            A função retorna um inteiro que representa o número de linhas a serem exibidas na seção 
            especificada. No exemplo dado, ela retorna o tamanho do array "pictures" como o número de 
            linhas a serem exibidas na tabela. Essa função é importante para que o UITableView saiba 
            quantas células deve exibir e assim, pode gerenciar o espaço e o conteúdo corretamente.
        */
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
		cell.textLabel?.text = pictures[indexPath.row]
		return cell

        /*
            Essa função é um método da classe UITableViewDataSource que é chamado pelo objeto UITableView 
            para fornecer uma célula (linha) para exibir em uma determinada posição (índice) na tabela. 
            Ele é usado para configurar e fornecer as células que serão exibidas na tabela. A função tem 
            dois parâmetros:

            tableView é uma referência para o objeto UITableView que está solicitando a célula.
            indexPath é o índice da linha para a qual a célula está sendo solicitada.

            A função retorna um objeto UITableViewCell que representa a célula a ser exibida na linha 
            especificada. A função usa o método "dequeueReusableCell" para obter uma célula reciclada do 
            UITableView, com um identificador "Picture" e configura o texto da célula para o valor 
            correspondente no array "pictures" e retorna essa célula. Essa função é chamada pela 
            UITableView quando precisa exibir uma nova célula e é fundamental para o funcionamento da 
            UITableView.
        */
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
			vc.selectedImage = pictures[indexPath.row]
			navigationController?.pushViewController(vc, animated: true)
		}

        /*
            Essa função é um método da classe UITableViewDelegate que é chamado quando o usuário seleciona 
            uma linha (célula) na tabela. Ele é usado para lidar com a interação do usuário com a tabela, 
            como a navegação para outras telas ou a exibição de informações adicionais. A função tem dois 
            parâmetros:

            tableView é uma referência para o objeto UITableView que está notificando a seleção da linha.
            indexPath é o índice da linha que foi selecionada.

            A função verifica se é possível instanciar um controlador de visualização 
            "DetailViewController" a partir do identificador "Detail" no storyboard, e se possível, 
            define a propriedade "selectedImage" com o valor correspondente no array "pictures" e 
            empilha esse controlador de visualização na hierarquia de navegação do aplicativo utilizando 
            o método "pushViewController" do navigationController. Isso fará com que o controlador de 
            visualização "DetailViewController" seja exibido na tela e o usuário possa navegar para ele.
        */
	}
}

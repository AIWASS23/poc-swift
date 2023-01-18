import UIKit

class ViewController: UIViewController {
	@IBOutlet var button1: UIButton!
	@IBOutlet var button2: UIButton!
	@IBOutlet var button3: UIButton!

	var countries = [String]()
	var correctAnswer = 0
	var score = 0

	override func viewDidLoad() {
		super.viewDidLoad()

		button1.layer.borderWidth = 1
		button2.layer.borderWidth = 1
		button3.layer.borderWidth = 1

		button1.layer.borderColor = UIColor.lightGray.cgColor
		button2.layer.borderColor = UIColor.lightGray.cgColor
		button3.layer.borderColor = UIColor.lightGray.cgColor

        /*
            No UIKit, a classe UIView é a principal classe que gerencia os layers e é a base para a maioria 
            das views em um aplicativo iOS. A classe UIView possui uma propriedade chamada layer, que é do 
            tipo CALayer e é responsável por gerenciar o conteúdo gráfico exibido pela view. Você pode 
            acessar essa propriedade para personalizar a aparência de uma view, como alterar a cor de 
            fundo, adicionar bordas ou sombra, ou até mesmo animar a view.Aqui estão alguns exemplos de 
            como você pode usar o método layer em UIKit:

            Alterar a cor de fundo de uma view:

            myView.layer.backgroundColor = UIColor.blue.cgColor

            Adicionar uma borda à view:

            myView.layer.borderWidth = 2
            myView.layer.borderColor = UIColor.black.cgColor

            Adicionar uma sombra à view:

            myView.layer.shadowRadius = 5
            myView.layer.shadowOffset = CGSize(width: 0, height: 3)
            myView.layer.shadowOpacity = 0.5

            Animar uma view:

            let animation = CABasicAnimation(keyPath: "position.x")
            animation.fromValue = myView.layer.position.x
            animation.toValue = myView.layer.position.x + 100
            animation.duration = 2
            myView.layer.add(animation, forKey: "position")

            É importante notar que, as vezes, algumas dessas configurações podem ser feitas diretamente 
            na interface do storyboard ou através de constraints.
        */

		countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
		askQuestion()
	}

	func askQuestion(action: UIAlertAction! = nil) {
		countries.shuffle() // Embaralha os elementos do array de strings

        /*
            UIAlertAction é uma classe do framework UIKit da Apple, que é usada para criar ações para 
            alertas (UIAlertController). Essas ações são os botões que podem ser adicionados ao alerta e 
            geralmente são usadas para fornecer opções ao usuário ou para realizar uma ação específica 
            quando o usuário seleciona um botão. Você pode criar uma instância de UIAlertAction passando 
            um título e um estilo (como .default ou .cancel) e, em seguida, adicioná-lo a um objeto 
            UIAlertController. Por exemplo:

            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                // código a ser executado quando o usuário seleciona OK
            }
            let alert = UIAlertController(title: "Título", message: "Mensagem", preferredStyle: .alert)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)

            Assim, ao tocar no botão "OK" será executado o código dentro do closure que foi passado ao 
            criar a UIAlertAction.
        */

		button1.setImage(UIImage(named: countries[0]), for: .normal)
		button2.setImage(UIImage(named: countries[1]), for: .normal)
		button3.setImage(UIImage(named: countries[2]), for: .normal)

        correctAnswer = Int.random(in: 0...2)
		title = countries[correctAnswer].uppercased()
	}

	@IBAction func buttonTapped(_ sender: UIButton) {
		var title: String

		if sender.tag == correctAnswer {
			title = "Correct"
			score += 1
		} else {
			title = "Wrong"
			score -= 1
		}

		let ac = UIAlertController(title: title, message: "Your score is \(score).", preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
		present(ac, animated: true)

        /*
            UIAlertController é uma classe do framework UIKit da Apple que fornece uma interface para criar 
            e exibir alertas e ações de sheet (como opções de compartilhamento) para o usuário em 
            aplicativos iOS. Ele permite personalizar a aparência e o comportamento dos alertas, 
            incluindo o título, a mensagem e os botões de ação. UIAlertController pode ser usado para 
            criar alertas simples, como alertas de erro ou alertas de confirmação, ou para criar alertas 
            mais complexos com vários botões de ação e campos de entrada de texto. Ele é geralmente usado 
            para exibir mensagens importantes para o usuário e para obter input dele.

            Essa função é uma função de ação de botão (IBAction) vinculada a um botão na interface do 
            usuário. Ela é chamada quando o botão é pressionado. A função verifica qual é a tag do botão 
            pressionado (sender.tag) e compara com a resposta correta (correctAnswer). Se a tag do botão 
            pressionado for igual à resposta correta, então o título da mensagem é definido como "Correct" 
            e a pontuação (score) é incrementada em 1. Se a tag do botão pressionado for diferente da 
            resposta correta, então o título da mensagem é definido como "Wrong" e a pontuação é 
            decrementada em 1. Em seguida, é criado um objeto UIAlertController (ac) com o título e a 
            mensagem que foi definida anteriormente. Adiciona-se uma ação de botão "Continue" para o 
            alerta, e ao selecionar essa ação, chama-se a função askQuestion. Apresenta-se o alerta para o 
            usuário com a pontuação atual.
        */
	}

}

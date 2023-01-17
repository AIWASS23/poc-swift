import UIKit

class DetailViewController: UIViewController {

    /*
        UIViewController é uma classe do framework UIKit para iOS e tvOS que fornece a base para a 
        implementação de controladores de visualização. Ele gerencia uma exibição e suas subviews, 
        além de fornecer recursos comuns como a navegação de pilha, gerenciamento de layout e atualização 
        de conteúdo. Uma UIViewController geralmente é responsável por gerenciar uma única tela de conteúdo 
        na interface do usuário e pode ser incorporado em outros controladores de visualização, como 
        UINavigationController e UITabBarController, para fornecer funcionalidades adicionais.

        @IBOutlet é um marcador de propriedade usado no iOS e tvOS para indicar que uma propriedade deve 
        ser exposta como um objeto conectável no Interface Builder. Isso permite que os desenvolvedores 
        conectem uma propriedade de uma classe a um elemento de interface do usuário no Interface Builder, 
        sem precisar escrever código para configurar a conexão. Uma propriedade marcada com @IBOutlet deve 
        ser uma referência opcional para um objeto UIView ou subclasse. Quando uma propriedade é conectada 
        a um elemento de interface do usuário no Interface Builder, o valor da propriedade é definido 
        automaticamente como o objeto correspondente na tela.
    */

	@IBOutlet var imageView: UIImageView!
	var selectedImage: String?

    override func viewDidLoad() {
        super.viewDidLoad()

		title = selectedImage
        navigationItem.largeTitleDisplayMode = .never

        /*
            navigationItem.largeTitleDisplayMode é uma propriedade do objeto UINavigationItem que 
            especifica como o título grande deve ser exibido na barra de navegação. A propriedade pode ser 
            definida como .never, o que significa que o título grande nunca será exibido. Isso é útil 
            quando você deseja ocultar o título grande em uma determinada tela da sua aplicação.
        */

		if let imageToLoad = selectedImage {
			imageView.image  = UIImage(named: imageToLoad)
		}
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true

        /*
            viewWillAppear(_:) é uma função de gancho de ciclo de vida da ViewController, ela é chamada 
            logo antes da view controller view ser adicionada ao view hierarchy. Essa função é sobreposta 
            para fornecer a lógica personalizada que deve ser executada antes de a view aparecer na tela.

            A função configura a propriedade hidesBarsOnTap do objeto navigationController para true. 
            hidesBarsOnTap é uma propriedade que permite que as barras de navegação e de ferramentas 
            sejam ocultadas ao tocar na tela. Isso significa que, quando a tela for exibida e o usuário 
            tocar na tela, as barras de navegação e de ferramentas serão ocultadas automaticamente.
        */
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false

        /*
            viewWillDisappear(_:) é uma função de gancho de ciclo de vida da ViewController, é chamada logo 
            antes da view controller ser removida do view hierarchy. Essa função é sobreposta para fornecer 
            a lógica personalizada que deve ser executada antes de a view desaparecer da tela.

            A função está configurando a propriedade hidesBarsOnTap do objeto navigationController para 
            false. hidesBarsOnTap é uma propriedade que permite que as barras de navegação e de ferramentas 
            sejam ocultadas ao tocar na tela. Isso significa que, quando a view estiver prestes a 
            desaparecer e o usuário tocar na tela, as barras de navegação e de ferramentas Não serão 
            ocultadas automaticamente.
        */
    }
}

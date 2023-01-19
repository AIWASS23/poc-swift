import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

	/*
	WKNavigationDelegate é um protocolo do framework WebKit que fornece métodos opcionais para monitorar e 
	controlar a navegação de uma instância de WKWebView. Ele oferece métodos para rastrear eventos como 
	carregamento de página, autenticação de usuário e decisões de navegação, entre outros. Ao implementar o 
	protocolo WKNavigationDelegate em sua classe, você pode atribuir essa classe como o delegate da sua 
	instância WKWebView. Isso permitirá que sua classe receba notificações de eventos de navegação e tome 
	decisões sobre como lidar com esses eventos. Exemplo:

	class ViewController: UIViewController, WKNavigationDelegate {
		override func viewDidLoad() {
			super.viewDidLoad()
			let webView = WKWebView()
			webView.navigationDelegate = self
		}

		func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
			print("Carregamento de página concluído!")
		}

		func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
			decisionHandler(.allow)
		}
	}
	Em resumo, o protocolo WKNavigationDelegate permite que você monitore e controle a navegação em uma 
	instância WKWebView, o que é útil quando você deseja tomar ações específicas em resposta a eventos de 
	navegação.
*/

	var webView: WKWebView!

	/*
		WKWebView é uma classe do framework WebKit da Apple, que fornece uma visualização da web para 
		aplicativos iOS. Ele é similar ao UIWebView, mas oferece melhor desempenho e recursos mais 
		recentes. Ele pode ser usado para carregar e exibir conteúdo da web dentro de um aplicativo iOS, 
		como páginas da web, arquivos HTML e outros documentos similares. No Swift, você pode criar uma 
		instância de WKWebView, configurar suas propriedades e adicioná-lo à sua visualização de interface 
		do usuário.
	*/

	var progressView: UIProgressView!

	/*
		UIProgressView é uma classe do UIKit que fornece uma barra de progresso para indicar o progresso de 
		uma tarefa. Ele pode ser usado para indicar o progresso de operações como carregamento de arquivos, 
		download de dados, etc. Ele é composto por uma barra preenchida, que pode ser estilizada com cores 
		e imagens, e um indicador de progresso, que pode ser animado para indicar o progresso da tarefa. No 
		Swift, você pode criar uma instância de UIProgressView, configurar suas propriedades e adicioná-lo 
		à sua visualização de interface do usuário. Você pode atualizar o progresso através de sua 
		propriedade progress, que é um valor flutuante de 0.0 a 1.0.
	*/

	var websites = ["apple.com", "globo.com"]

	override func loadView() {
		webView = WKWebView()
		webView.navigationDelegate = self
		view = webView

		/*
			override func loadView() é um método que pertence à classe UIViewController do UIKit. Ele é 
			chamado quando a visualização da interface do usuário precisa ser carregada pela primeira vez. 
			A implementação padrão deste método cria uma instância de UIView e a atribui à propriedade 
			"view" do controlador de visualização. Você pode sobrepor este método em sua subclasse de 
			UIViewController para fornecer sua própria visualização personalizada. Por exemplo, você pode 
			criar sua própria subclasse de UIView ou outro objeto de visualização, configurá-lo e atribuí-lo
			à propriedade "view" do controlador de visualização, como:

			override func loadView() {
				let myView = MyCustomView()
				self.view = myView
			}

			É importante notar que é recomendado que você chame a implementação super do método loadView() 
			se você estiver criando a sua própria visualização, pois isso garante que a cadeia de 
			responsabilidade do carregamento da visualização funcione corretamente.



		*/
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		let url = URL(string: "https://" + websites[0])!
		webView.load(URLRequest(url: url))
		webView.allowsBackForwardNavigationGestures = true

		/*
			allowsBackForwardNavigationGestures é uma propriedade booleana da classe WKWebView do WebKit que 
			indica se os gestos de navegação para trás e para frente devem ser habilitados ou não. Quando 
			esta propriedade é definida como "true", os usuários podem deslizar para a esquerda ou direita 
			na tela para navegar para trás ou para frente na história de navegação do WKWebView. Quando 
			esta propriedade é definida como "false", esses gestos são desativados e os usuários não podem 
			navegar usando esses gestos.
		*/

		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))

		/*
			Esse comando adiciona um botão à barra de navegação do controlador de visualização atual. Ele 
			cria uma instância de UIBarButtonItem com o título "Open", o estilo "plain" 
			(sem estilo específico), o alvo "self" (o controlador de visualização atual) e a ação 
			"openTapped" (um método seletor que deve ser implementado pelo controlador de visualização). 
			Em seguida, ele atribui essa instância de UIBarButtonItem à propriedade "rightBarButtonItem" 
			do objeto "navigationItem" do controlador de visualização. A propriedade "navigationItem" é um 
			objeto que contém informações sobre a visualização atual na barra de navegação. Ele fornece 
			acesso às propriedades de título, botões de barra e outros elementos da barra de navegação. A 
			propriedade "rightBarButtonItem" é uma propriedade do objeto "navigationItem" que especifica o 
			botão que será exibido no lado direito da barra de navegação. O método openTapped() é um método 
			seletor que deve ser implementado pelo controlador de visualização e é chamado quando o botão 
			"Open" é tocado. O que esse método faz depende da implementação, mas geralmente é usado para 
			abrir algum tipo de conteúdo ou recurso.
		*/

		progressView = UIProgressView(progressViewStyle: .default)
		progressView.sizeToFit()
		let progressButton = UIBarButtonItem(customView: progressView)

		/*
			A linha de código acima cria uma instância de UIBarButtonItem com um customView que é uma 
			instância de progressView. Isso adiciona uma visualização de progresso como um botão na barra 
			de navegação de um aplicativo iOS. O progresso pode ser controlado alterando a propriedade 
			progress do objeto progressView.
		*/

		let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))

		/*
			Esse código cria uma instância de UIBarButtonItem usando o sistema de botão de barra .refresh, 
			com o alvo especificado como webView e a ação especificada como #selector(webView.reload). Isso 
			adiciona um botão "atualizar" na barra de navegação de um aplicativo iOS, e quando esse botão é 
			clicado, ele chama o método reload do objeto webView. O efeito seria recarregar a pagina atual 
			que o usuário esta visualizando no webView.
		*/

		toolbarItems = [progressButton, spacer, refresh]
		navigationController?.isToolbarHidden = false

		/*
			A linha de código acima faz com que a barra de ferramentas seja exibida se ela estiver 
			escondida. Ela está acessando a propriedade isToolbarHidden do objeto navigationController e 
			definindo-a como false. Isso vai mostrar a barra de ferramentas do aplicativo, permitindo que 
			os itens adicionados anteriormente na propriedade toolbarItems sejam exibidos para o usuário.
		*/

		webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)

		/*
			A linha de código acima adiciona um observador para o objeto webView para a propriedade 
			estimatedProgress usando o método addObserver. Ele especifica que o observador é "self" 
			(provavelmente a própria classe), e especifica o caminho da chave como 
			#keyPath(WKWebView.estimatedProgress). A opção .new é passada como um argumento para indicar que o 
			observador deve ser notificado somente quando o valor da propriedade muda. E o contexto é nulo. 
			A propriedade estimatedProgress indica o progresso estimado do carregamento da página atual no 
			objeto webView, ou seja, esse código está adicionando o controle de progresso do carregamento de 
			página no webView.
		*/
	}

	@objc func openTapped() {
		let ac = UIAlertController(title: "Open page…", message: nil, preferredStyle: .actionSheet)

		for website in websites {
			ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
		}

		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
		present(ac, animated: true)
	}

	func openPage(action: UIAlertAction) {
		let url = URL(string: "https://" + action.title!)!
		webView.load(URLRequest(url: url))
	}

	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		title = webView.title
	}

	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		let url = navigationAction.request.url

		if let host = url?.host {
			for website in websites {
				if host.contains(website) {
					decisionHandler(.allow)
					return
				}
			}
		}

		decisionHandler(.cancel)
	}

	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if keyPath == "estimatedProgress" {
			progressView.progress = Float(webView.estimatedProgress)
		}

		/*
			A função acima é um método de observador chamado quando uma propriedade observada muda. Ele 
			verifica se o caminho da chave é "estimatedProgress" e, se for, atribui o valor da propriedade 
			estimatedProgress do objeto webView como o progresso da propriedade progress do objeto 
			progressView. Isso permite que o progresso do carregamento da página no objeto webView seja 
			mostrado na barra de progresso progressView. Essa função é chamada automaticamente quando o 
			valor da propriedade "estimatedProgress" é alterado, e essa implementação atualiza a barra de 
			progresso com o novo valor.
		*/
	}
}

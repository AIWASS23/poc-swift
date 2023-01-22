import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: Petition?

    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let detailItem = detailItem else { return }

        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body { font-size: 150%; } </style>
        </head>
        <body>
        \(detailItem.body)
        </body>
        </html>
        """

        webView.loadHTMLString(html, baseURL: nil)

        /*
            Esse comando faz o carregamento de uma string HTML em um objeto webView. O objeto webView é 
            geralmente uma instância de UIWebView ou WKWebView, que são componentes da interface do usuário 
            que exibem páginas da web.

            A string HTML é passada como o primeiro parâmetro para o método loadHTMLString e é o código HTML
            que deve ser exibido na visualização da web. O segundo parâmetro, baseURL, é opcional e é usado 
            para especificar o local a partir do qual os recursos relacionados (como imagens, folhas de 
            estilo e scripts) devem ser carregados. Se esse parâmetro for passado como "nil", os recursos 
            relacionados serão procurados na mesma localização do arquivo HTML.

            Esse comando é útil quando você deseja exibir conteúdo HTML dinâmico dentro da sua aplicação, s
            em precisar carregar uma página da web externa. Ele também pode ser usado para exibir 
            conteúdo HTML estático que você deseja incluir diretamente na sua aplicação.
        */
    }
}

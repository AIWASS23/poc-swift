import UIKit

/*
    Auto Layout é um mecanismo de layout de interface do usuário presente no iOS que permite a você definir 
    relações entre elementos visuais em sua interface, ao invés de posicioná-los manualmente usando 
    coordenadas fixas. Isso permite que a sua interface se adapte automaticamente às diferentes tamanhos de 
    tela, orientações e idiomas. Auto Layout utiliza uma série de regras e restrições para determinar como 
    os elementos visuais devem se posicionar e dimensionar. Essas regras e restrições podem ser definidas 
    visualmente no Interface Builder, ou programaticamente usando o código. Auto Layout é baseado em uma 
    série de restrições que você pode definir entre elementos visuais. Essas restrições especificam como 
    os elementos visuais devem se posicionar e dimensionar em relação aos outros elementos visuais e às 
    bordas da superview. Em resumo, Auto Layout é uma ferramenta poderosa para criar interfaces de usuário 
    flexíveis e adaptáveis no iOS. Ele permite que você defina relações entre elementos visuais e garante 
    que sua interface se adapte automaticamente às diferentes tamanhos de tela, orientações e idiomas.
*/

class ViewController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()

		let label1 = UILabel()
		label1.translatesAutoresizingMaskIntoConstraints = false
		label1.backgroundColor = UIColor.red
		label1.text = "THESE"

        /*
            translatesAutoresizingMaskIntoConstraints é uma propriedade booleana presente em várias classes 
            do framework UIKit do iOS, incluindo UIView. Essa propriedade determina se as máscaras de 
            redimensionamento (autoresizing masks) de uma visualização devem ser convertidas em restrições 
            de layout de Auto Layout. Por padrão, essa propriedade é definida como "true", o que significa 
            que as máscaras de redimensionamento serão convertidas em restrições de layout de Auto Layout. 
            Isso pode ser útil se você estiver migrando uma interface antiga para o Auto Layout e desejar 
            manter o comportamento de layout existente enquanto adiciona restrições adicionais. Se você 
            deseja desativar essa conversão e usar somente as restrições de Auto Layout que você define 
            explicitamente, você pode definir essa propriedade como "false". Isso pode ser feito 
            programaticamente: myView.translatesAutoresizingMaskIntoConstraints = false
            É importante lembrar que, se você definir essa propriedade como "false", você deve definir 
            explicitamente todas as restrições de layout necessárias para garantir que a visualização seja 
            posicionada e dimensionada corretamente.
        */

		let label2 = UILabel()
		label2.translatesAutoresizingMaskIntoConstraints = false
		label2.backgroundColor = UIColor.cyan
		label2.text = "ARE"

		let label3 = UILabel()
		label3.translatesAutoresizingMaskIntoConstraints = false
		label3.backgroundColor = UIColor.yellow
		label3.text = "SOME"

		let label4 = UILabel()
		label4.translatesAutoresizingMaskIntoConstraints = false
		label4.backgroundColor = UIColor.green
		label4.text = "AWESOME"

		let label5 = UILabel()
		label5.translatesAutoresizingMaskIntoConstraints = false
		label5.backgroundColor = UIColor.orange
		label5.text = "LABELS"

		view.addSubview(label1)
		view.addSubview(label2)
		view.addSubview(label3)
		view.addSubview(label4)
		view.addSubview(label5)

        /*
            addSubview(_:) é um método presente na classe UIView do UIKit que é usado para adicionar uma 
            subview (ou seja, uma visualização filha) a uma view (ou seja, uma visualização pai). 
            Ele adiciona a subview como a última subview na lista de subviews do pai. A sintaxe é a seguinte:

            myParentView.addSubview(myChildView)

            Esse método adiciona a subview passada como argumento como uma subview da view pai 
            (myParentView) e a subview passada como argumento (myChildView) passa a ser uma subview da 
            view pai. Essa é uma forma de construir a hierarquia de views em uma interface, onde a view pai 
            contém várias subviews e cada subview pode ter suas próprias subviews. Isso permite organizar 
            a interface de forma hierárquica e facilita a gestão de eventos e layout.

            Além de addSubview existem outros métodos que permitem adicionar subviews como:
            insertSubview(_:at:)
            insertSubview(_:aboveSubview:) 
            insertSubview(_:belowSubview:)  
            bringSubviewToFront(_:)  
            sendSubviewToBack(_:)
            exchangeSubview(at: withSubviewAt:)
        */

		let viewsDictionary = ["label1": label1, "label2": label2, "label3": label3, "label4": label4, "label5": label5]


		for label in viewsDictionary.keys {
			view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[\(label)]|", options: [], metrics: nil, views: viewsDictionary))

            /*
                addConstraints(_:) é um método presente na classe NSLayoutConstraint do UIKit que é usado 
                para adicionar restrições de layout a uma view. Ele adiciona as restrições passadas como 
                argumento à lista de restrições da view. A sintaxe é a seguinte:

                myView.addConstraints(myConstraints)

                Esse método adiciona as restrições passadas como argumento (myConstraints) à view (myView) 
                e essas restrições são usadas pelo Auto Layout para calcular a posição e o tamanho da view. 
                As restrições são definidas usando objetos NSLayoutConstraint, que podem ser criados 
                programaticamente ou visualmente no Interface Builder. Cada restrição especifica uma 
                relação entre um ou mais elementos visuais, como a distância entre eles, suas proporções, 
                seus tamanhos, etc. Além de addConstraints(_:), existem outros métodos relacionados a 
                restrições de layout, como: 

                removeConstraints(_:) que remove as restrições especificadas da view 
                updateConstraints() e updateConstraintsIfNeeded() que permite atualizar as restrições 
                existentes. 

                Além disso, existem também métodos para recuperar as restrições existentes em uma view, como:

                constraints
                constraintsAffectingLayout(for:).

                Em resumo, o método addConstraints(_:) é usado para adicionar restrições de layout a uma view 
                e essas restrições são usadas pelo Auto Layout para calcular a posição e o tamanho da view. 
                É possível criar e gerenciar essas restrições tanto programaticamente quanto visualmente, 
                e existem vários outros métodos relacionados a restrições de layout disponíveis na classe 
                NSLayoutConstraint.
            */
		}

		let metrics = ["labelHeight": 88]
		view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:"V:|[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]->=10-|", options: [], metrics: metrics, views: viewsDictionary))

		var previous: UILabel?

		for label in [label1, label2, label3, label4, label5] {
			label.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
			label.heightAnchor.constraint(equalToConstant: 88).isActive = true

            // https://developer.apple.com/documentation/uikit/nslayoutdimension

			if let previous = previous {
                label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
			}

			previous = label

            /*
                Existem vários tipos de ancoradores de layout disponíveis no UIKit os principais são:

                leadingAnchor: representa o ancorador da margem esquerda da view.
                trailingAnchor: representa o ancorador da margem direita da view.
                topAnchor: representa o ancorador da margem superior da view.
                bottomAnchor: representa o ancorador da margem inferior da view.
                widthAnchor: representa o ancorador da largura da view.
                heightAnchor: representa o ancorador da altura da view.
                centerXAnchor: representa o ancorador do centro da view no eixo X.
                centerYAnchor: representa o ancorador do centro da view no eixo Y.
                firstBaselineAnchor: representa o ancorador da primeira linha de texto de uma view de texto.
                lastBaselineAnchor: representa o ancorador da última linha de texto de uma view de texto.
                rigthAnchor: representa o ancorador a direita.
                leftAnchor: representa o ancorador a esquerda.
            */
		}
	}

    override var prefersStatusBarHidden: Bool {
        return true

        /*
            prefersStatusBarHidden é uma propriedade da classe UIViewController que indica se a barra de 
            status deve ser oculta ou exibida quando a visualização estiver sendo exibida. A propriedade é 
            do tipo Bool, onde true significa que a barra de status deve ser oculta e false significa que 
            deve ser exibida. Ao sobrescrever essa propriedade, você pode especificar se deseja ocultar ou 
            exibir a barra de status para a visualização controlada pelo ViewController. É importante notar 
            que essa propriedade só funciona se o valor da propriedade prefersStatusBarHidden for true, 
            e se a propriedade isModal for false, caso contrário, a barra de status sempre será exibida.
        */
    }
}


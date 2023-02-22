import UIKit

/*
    Quando o botão é pressionado, a função tapped é chamada. Essa função esconde o botão de "tap" e, em 
    seguida, inicia uma animação na imagem que é exibida na tela. A animação é controlada pela variável 
    currentAnimation que é incrementada a cada vez que o botão é pressionado.

    Existem oito animações possíveis que podem ocorrer, cada uma definida por um case diferente no 
    switch-case dentro da função de animação. As animações incluem a escala (scale), a translação 
    (translation), a rotação (rotation), a mudança de cor de fundo (background color) e a alteração da 
    opacidade (alpha) da imagem.

    Quando a animação termina, a função de conclusão (completion handler) é chamada para exibir novamente o 
    botão de "tap".
*/

class ViewController: UIViewController {
	@IBOutlet var tap: UIButton!

	var imageView: UIImageView!
	var currentAnimation = 0

	override func viewDidLoad() {
		super.viewDidLoad()

		imageView = UIImageView(image: UIImage(named: "penguin"))
		imageView.center = CGPoint(x: 512, y: 384)
		view.addSubview(imageView)
	}

	@IBAction func tapped(_ sender: AnyObject) {
		tap.isHidden = true

        /*
            O método isHidden é uma propriedade da classe UIView. Ele é usado para controlar a visibilidade 
            de uma visualização (view). Quando o valor da propriedade isHidden é definido como true, a 
            visualização se torna invisível e não é exibida na tela. Quando é definido como false, a 
            visualização se torna visível e é exibida na tela. O método isHidden é frequentemente usado em 
            conjunto com a animação de interface do usuário. Por exemplo, pode-se esconder um botão quando 
            ele é pressionado para evitar a interação repetida do usuário durante a animação, e depois 
            exibir o botão novamente após a animação ter terminado.
        */

		UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [],
		   animations: { [unowned self] in
			switch self.currentAnimation {
			case 0:
				self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
			case 1:
				self.imageView.transform = CGAffineTransform.identity
			case 2:
				self.imageView.transform = CGAffineTransform(translationX: -256, y: -256)
			case 3:
				self.imageView.transform = CGAffineTransform.identity
			case 4:
				self.imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
			case 5:
				self.imageView.transform = CGAffineTransform.identity
			case 6:
				self.imageView.alpha = 0.1
				self.imageView.backgroundColor = UIColor.green
			case 7:
				self.imageView.alpha = 1
				self.imageView.backgroundColor = UIColor.clear
			default:
				break

            /*
                CGAffineTransform é uma estrutura da biblioteca de gráficos (Graphics) do Core Graphics 
                framework no iOS. É usada para representar transformações geométricas em duas dimensões (2D), 
                como rotação, escala, translação e inclinação. No Swift, você pode criar uma matriz de 
                transformação CGAffineTransform usando a função 
                CGAffineTransform(a:b:c:d:tx:ty:), onde a, b, c, d, tx e ty são os componentes da matriz.
                Você também pode criar transformações de forma mais fácil e legível usando as funções de 
                conveniência fornecidas pelo CGAffineTransform. Alguns exemplos incluem:

                CGAffineTransform.identity: cria a matriz de transformação de identidade (não transforma).

                CGAffineTransform(translationX:y:): cria a matriz de translação especificada pelos valores x e y.

                CGAffineTransform(scaleX:y:): cria a matriz de escala especificada pelos valores x e y.

                CGAffineTransform(rotationAngle:): cria a matriz de rotação especificada pelo ângulo theta em radianos.

                CGAffineTransform também pode ser usada em conjunto com a animação de interface do usuário, 
                permitindo que você aplique transformações suaves e graduais em uma visualização, como animar a 
                escala, a rotação e a translação da visualização. Isso pode ser feito usando o método 
                UIView.animate(withDuration:delay:options:animations:completion:) do UIKit, passando a transformação 
                que deseja animar no bloco de animações.
            */

			}
		}) { [unowned self] (finished: Bool) in
			self.tap.isHidden = false
		}

		currentAnimation += 1

		if currentAnimation > 7 {
			currentAnimation = 0
		}
	}
}


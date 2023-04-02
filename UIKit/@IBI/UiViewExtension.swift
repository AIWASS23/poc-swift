import UIKit

@IBDesignable extension UIView {

    /*
        A anotação @IBDesignable é uma diretiva do Xcode que permite que você veja as alterações 
        feitas em uma UIView personalizada em tempo real na interface de design do Interface Builder. 
        Para utilizar esta diretiva, é necessário definir sua classe personalizada para conformar a 
        protocolo IBDesignable e colocar a diretiva na classe.

        https://developer.apple.com/documentation/uikit/ibdesignable
    */
    
    @IBInspectable var borderColor: UIColor? {

        /*
            O IBInspectable permite que você exponha as propriedades de uma classe em Interface 
            Builder, tornando mais fácil para os desenvolvedores ajustar a aparência e o 
            comportamento de seus objetos visuais.

            https://developer.apple.com/documentation/uikit/ibinspectable
        */

        set { layer.borderColor = newValue?.cgColor }
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        set { layer.borderWidth = newValue }
        get { layer.borderWidth }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get { layer.cornerRadius}
    }
}

/*
    A extensão para UIView adiciona três propriedades inspecionáveis (@IBInspectable): borderColor, 
    borderWidth e cornerRadius. Essas propriedades permitem configurar a borda de uma view 
    diretamente no Interface Builder do Xcode, sem a necessidade de código adicional.

    A propriedade borderColor define a cor da borda, a propriedade borderWidth define a largura da 
    borda e a propriedade cornerRadius define o raio dos cantos da view. Todas as três propriedades 
    são animáveis e suportam a configuração no tempo de design.

    Essas propriedades são usadas em projetos do iOS para customizar a aparência das views, 
    fornecendo uma maneira fácil de adicionar bordas e cantos arredondados a views em seu aplicativo.
*/

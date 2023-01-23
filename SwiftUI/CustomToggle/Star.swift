import SwiftUI

struct Star: Shape {
    // armazena quantos cantos a estrela tem, e quão lisa/pontiaguda ela é
    let corners: Int
    let smoothness: Double
    
    func path(in rect: CGRect) -> Path {
        // garante que teremos pelo menos dois cantos, caso contrário, envie de volta um caminho vazio
        guard corners >= 2 else { return Path() }
        
        // desenha para o centro do nosso retângulo
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        
        // começa diretamente para cima (ao contrário de para baixo ou para a direita)
        var currentAngle = -CGFloat.pi / 2
        
        // calcula quanto precisamos mover com cada canto da estrela
        let angleAdjustment = .pi * 2 / Double(corners * 2)
        
        // analisa quanto precisamos mover X/Y para os pontos internos da estrela
        let innerX = center.x * smoothness
        let innerY = center.y * smoothness
        
        // Inicio
        var path = Path()
        
        // move para a nossa posição inicial
        path.move(to: CGPoint(x: center.x * cos(currentAngle), y: center.y * sin(currentAngle)))
        
        // rastrea o ponto mais baixo para o qual desenhamos, para que possamos centralizar depois
        var bottomEdge: Double = 0
        
        // percorre todos os nossos pontos/pontos internos
        for corner in 0..<corners * 2  {

            // descobre a localização deste ponto
            let sinAngle = sin(currentAngle)
            let cosAngle = cos(currentAngle)
            let bottom: Double
            
            // se for múltiplo de 2, estamos desenhando a borda externa da estrela
            if corner.isMultiple(of: 2) {
                // armazena esta posição Y
                bottom = center.y * sinAngle
                
                // adiciona uma linha 
                path.addLine(to: CGPoint(x: center.x * cosAngle, y: bottom))
            } else {
                // se não for múltiplo de 2, o que significa que estamos desenhando um ponto interno

                // armazena esta posição Y
                bottom = innerY * sinAngle
                
                // adiciona uma linha 
                path.addLine(to: CGPoint(x: innerX * cosAngle, y: bottom))
            }
            
            // se este novo ponto inferior for o mais baixo, guarda ele para mais tarde
            if bottom > bottomEdge {
                bottomEdge = bottom
            }
            
            // passa para a próxima esquina
            currentAngle += angleAdjustment
        }
        
        // descobre quanto espaço não utilizado tem na parte inferior do nosso retângulo de desenho
        let unusedSpace = (rect.height / 2 - bottomEdge) / 2
        
        // cria e aplica a transformação que move o caminho para baixo nessa quantidade, centralizando a forma verticalmente
        let transform = CGAffineTransform(translationX: center.x, y: center.y + unusedSpace)
        return path.applying(transform)

        /*
            CGAffineTransform é uma estrutura do Core Graphics (Core Graphics) no iOS e macOS que contém 
            informações sobre transformações afins. As transformações afins incluem operações como 
            translação (movimento), rotação, escala e reflexão. Você pode usar CGAffineTransform para 
            aplicar transformações a elementos de visualização, como imagens, formas e texto. Por exemplo, 
            você pode usar CGAffineTransform para rotacionar uma imagem em 45 graus:

            let rotation = CGAffineTransform(rotationAngle: .pi / 4)
            imageView.transform = rotation

            Você também pode combinar várias transformações usando operações aritméticas, como adição ou 
            concatenação. Por exemplo, você pode escala um elemento em x2 e rotacionar em 45 graus:

            let scale = CGAffineTransform(scaleX: 2, y: 2)
            let rotation = CGAffineTransform(rotationAngle: .pi / 4)
            let combined = scale.concatenating(rotation)
            imageView.transform = combined

            É importante lembrar que as operações são feitas na ordem inversa, ou seja, a última operação é 
            aplicada primeiro e as anteriores depois.
        */
    }
}
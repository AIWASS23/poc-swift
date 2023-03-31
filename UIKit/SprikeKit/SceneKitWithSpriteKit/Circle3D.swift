import SceneKit

class SphereSCNNode: SCNNode {

    init(color: UIColor) {
        super.init()

        let sphereGeometry = SCNSphere(radius: 1)
        sphereGeometry.materials.first?.diffuse.contents = color

        self.geometry = sphereGeometry
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/*
    A classe SphereSCNNode que herda de SCNNode. A classe cria um nó de cena 3D para uma esfera com uma cor personalizada.

    O método init da classe recebe um parâmetro color que é usado para definir a cor da esfera. Dentro do construtor, uma 
    geometria de esfera é criada com um raio de 1 unidade usando SCNSphere(radius: 1). O primeiro material da geometria da 
    esfera é obtido e a cor difusa é definida com o conteúdo do parâmetro color recebido no construtor.

    Por fim, a geometria da esfera modificada é definida como geometria do nó da cena, e esse nó é retornado como resultado do 
    construtor.
*/
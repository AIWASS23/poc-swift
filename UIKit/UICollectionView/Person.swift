import UIKit

class Person: NSObject, NSCoding {
	var name: String
	var image: String

	init(name: String, image: String) {
		self.name = name
		self.image = image
	}

	required init(coder aDecoder: NSCoder) {
		name = aDecoder.decodeObject(forKey: "name") as! String
		image = aDecoder.decodeObject(forKey: "image") as! String

		/*
			"required" é uma palavra-chave usada em Swift para especificar que uma determinada inicialização 
			é obrigatória em todas as subclasses de uma classe. A palavra-chave "required" garante que as 
			subclasses implementem o inicializador especificado, evitando que as subclasses possam ser 
			criadas sem ele.
		*/
	}

	func encode(with aCoder: NSCoder) {
		aCoder.encode(name, forKey: "name")
		aCoder.encode(image, forKey: "image")
	}
}

/*
    NSObject é a classe raiz da maioria das hierarquias de classe Objective-C. Ele fornece métodos e 
    propriedades básicos que são usados por todas as outras classes. Ele define a interface básica para 
    objetos em Objective-C, como gerenciamento de memória, reflexão e serialização. NSObject também fornece 
    uma implementação básica do protocolo de cópia, permitindo que os objetos sejam copiados facilmente.

	NSCoding é um protocolo em Objective-C que permite que objetos sejam codificados e decodificados para 
	arquivamento ou transmissão. Ele permite que os desenvolvedores salvem o estado de um objeto e o 
	restaurem posteriormente. Isso é feito implementando dois métodos: encodeWithCoder e initWithCoder. 
	O método encodeWithCoder codifica as propriedades do objeto em um objeto NSCoder, enquanto o método 
	initWithCoder decodifica o objeto de um objeto NSCoder e restaura suas propriedades.
*/
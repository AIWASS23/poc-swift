import UIKit

class Person: NSObject {
	var name: String
	var image: String

	init(name: String, image: String) {
		self.name = name
		self.image = image
	}
}

/*
    NSObject é a classe raiz da maioria das hierarquias de classe Objective-C. Ele fornece métodos e 
    propriedades básicos que são usados por todas as outras classes. Ele define a interface básica para 
    objetos em Objective-C, como gerenciamento de memória, reflexão e serialização. NSObject também fornece 
    uma implementação básica do protocolo de cópia, permitindo que os objetos sejam copiados facilmente.
*/
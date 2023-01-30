import UIKit

/*
    Esse é um código de uma classe ViewController no iOS com Swift, que implementa uma 
    UICollectionViewController para exibir uma lista de "pessoas". Cada pessoa é representada por uma imagem 
    e um nome. O usuário pode adicionar uma nova pessoa usando a UIImagePickerController para selecionar uma 
    imagem. A imagem é salva no diretório de documentos do aplicativo e o nome é inicialmente definido como 
    "Desconhecido". Quando a pessoa é selecionada, o usuário pode renomear a pessoa usando um alerta.
*/

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	var people = [Person]()

	/*
		UIImagePickerControllerDelegate é um protocolo que define métodos a serem implementados por um 
		delegate de um objeto UIImagePickerController. Ele permite que o delegate seja notificado quando o 
		usuário seleciona uma imagem ou filme ou cancela a operação do seletor. O delegate também pode ser 
		notificado quando a imagem ou filme foi editado.

		UINavigationControllerDelegate é um protocolo na estrutura UIKit que fornece métodos para responder 
		a eventos em um controlador de navegação. Ele permite que um objeto seja notificado quando o 
		controlador de navegação mostra ou oculta um controlador de exibição e quando o usuário navega de um 
		controlador de exibição para outro. Ele também fornece métodos para personalizar o comportamento da 
		barra de navegação, como definir sua cor de tonalidade e imagem de fundo.
	*/

	override func viewDidLoad() {
		super.viewDidLoad()

		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
	}

	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return people.count
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as! PersonCell

		let person = people[indexPath.item]

		cell.name.text = person.name

		let path = getDocumentsDirectory().appendingPathComponent(person.image)
		cell.imageView.image = UIImage(contentsOfFile: path.path)

		cell.imageView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
		cell.imageView.layer.borderWidth = 2
		cell.imageView.layer.cornerRadius = 3
		cell.layer.cornerRadius = 7

		return cell
	}

	@objc func addNewPerson() {
		let picker = UIImagePickerController()
		picker.allowsEditing = true
		picker.delegate = self
		present(picker, animated: true)

		/*
			Esta função adiciona uma nova pessoa ao aplicativo. Ele cria uma instância de 
			UIImagePickerController e define sua propriedade allowEditing como true. Em seguida, ele define 
			o delegate do selecionador como self e o apresenta com uma animação.
		*/
	}

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let image = info[.originalImage] as? UIImage else { return }

		let imageName = UUID().uuidString
		let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
			try? jpegData.write(to: imagePath)
		}

		let person = Person(name: "Unknown", image: imageName)
		people.append(person)
		collectionView?.reloadData()

		dismiss(animated: true)

		/*
			Esta função é usada para selecionar uma imagem do dispositivo do usuário e adicioná-la ao 
			aplicativo. Ele começa obtendo a imagem original do dicionário de informações e, em seguida, 
			cria um nome de imagem exclusivo usando UUID().uuidString. Em seguida, ele cria um caminho de 
			imagem usando a função getDocumentsDirectory() e anexando o imageName. O jpegData da imagem é 
			então gravado no imagePath. Um objeto Person é então criado com um nome "Desconhecido" e uma 
			imagem igual a imageName. Esse objeto Person é então anexado ao array de pessoas e 
			collectionView?.reloadData() é chamado para recarregar os dados na exibição da coleção. Por fim, 
			dispense(animated: true) é chamado para descartar o UIImagePickerController.
		*/
	}

	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let person = people[indexPath.item]

		let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
		ac.addTextField()

		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

		ac.addAction(UIAlertAction(title: "OK", style: .default) { [unowned self, ac] _ in
			let newName = ac.textFields![0]
			person.name = newName.text!

			self.collectionView?.reloadData()
		})

		present(ac, animated: true)
	}

	func getDocumentsDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		let documentsDirectory = paths[0]
		return documentsDirectory

		/*
			Esta função retorna a URL do diretório de documentos no dispositivo do usuário. Ele usa a classe 
			FileManager para obter uma matriz de URLs para o diretório de documentos no userDomainMask e, em 
			seguida, retorna a primeira URL dessa matriz.
		*/
}

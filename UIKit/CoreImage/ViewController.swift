import CoreImage
import UIKit

/*
    Este código é uma classe de visualização de aplicativo para iOS escrito em Swift que permite ao usuário 
    importar uma imagem, aplicar filtros de imagem (CISepiaTone, CIBumpDistortion, CIGaussianBlur, CIPixellate, 
    CITwirlDistortion, CIUnsharpMask, CIVignette) a ela e salvar a imagem resultante.

    A classe herda de UIViewController e implementa UIImagePickerControllerDelegate e UINavigationControllerDelegate 
    para permitir a seleção de imagens. A classe contém uma instância de UIImageView para exibir a imagem, 
    uma instância de UISlider para controlar a intensidade dos filtros e várias propriedades para armazenar a 
    imagem atual, o filtro atual e o contexto de imagem (Core Image Context).

    Ao carregar a tela, o título é definido como "YACIFP" e um botão é adicionado na barra de navegação para 
    importar uma imagem. O filtro padrão é definido como CISepiaTone. O usuário pode selecionar um filtro 
    diferente ao pressionar o botão "Change Filter". O botão "Save" permite salvar a imagem resultante. 
    O usuário pode controlar a intensidade dos filtros deslizando o slider "Intensity".

    Quando o usuário seleciona uma imagem, ela é armazenada na propriedade "currentImage" e definida como 
    entrada para o filtro atual. A função "applyProcessing" aplica o filtro a imagem e atualiza a imagem 
    exibida na UIImageView. A função "setFilter" define o filtro atual com base na seleção do usuário. 
    A função "image(_:didFinishSavingWithError:contextInfo:)" é chamada após o usuário salvar a imagem e 
    exibe uma mensagem de erro se houver algum problema.
*/

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var intensity: UISlider!
    var currentImage: UIImage!
    
    var currentFilter: CIFilter!
    let context = CIContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "YACIFP"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        currentFilter = CIFilter(name: "CISepiaTone")
    }
    
    @IBAction func changeFilter(_ sender: Any) {
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
    
    @IBAction func save(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(imageView.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @IBAction func intensityChanged(_ sender: Any) {
        applyProcessing()

        /*
            A palavra-chave Any em Swift representa um tipo de valor que pode ser qualquer coisa, incluindo 
            uma função ou uma classe. Ela é usada para definir variáveis ou constantes com tipo genérico, ou 
            seja, que possam conter valores de qualquer tipo sem precisar especificá-lo. Isso é útil quando 
            você não sabe ou não quer especificar o tipo de dados que uma variável irá conter, por exemplo, 
            em um array onde você quer armazenar valores de diferentes tipos.
        */
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        
        currentImage = image
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(intensity.value * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey) }
        if inputKeys.contains(kCIInputCenterKey) { currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey) }
        
        if let cgimg = context.createCGImage(currentFilter.outputImage!, from: currentFilter.outputImage!.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            self.imageView.image = processedImage
        }
    }
    
    
    func setFilter(action: UIAlertAction) {
        guard currentImage != nil else { return }
        
        currentFilter = CIFilter(name: action.title!)
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}
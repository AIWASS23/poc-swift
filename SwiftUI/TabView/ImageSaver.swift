import UIKit

/*
    A implementação do ImageSaver é usada para salvar uma imagem em álbum de fotos do dispositivo. A classe 
    contém dois handlers, successHandler e errorHandler, que são chamados dependendo do resultado da 
    operação de salvar a imagem. A classe contém uma função writeToPhotoAlbum que recebe uma imagem do tipo 
    UIImage e usa a função UIImageWriteToSavedPhotosAlbum para salvar a imagem no álbum de fotos. 
    Esta função tem como segundo parâmetro o próprio objeto da classe, o terceiro parâmetro é a função 
    que será chamada quando a operação for completada. A função saveCompleted é chamada quando a operação 
    de salvar a imagem for completada, essa função verifica se houve algum erro ao salvar a imagem, 
    se sim, chama o errorHandler, se não, chama o successHandler.
*/

class ImageSaver: NSObject {
    var successHandler: (() -> Void)?
    var errorHandler: ((Error) -> Void)?

    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            errorHandler?(error)
        } else {
            successHandler?()
        }
    }
}

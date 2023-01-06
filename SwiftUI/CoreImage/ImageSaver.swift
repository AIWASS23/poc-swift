import UIKit

/*
    A classe ImageSaver que pode ser usada para salvar imagens no álbum de fotos do usuário. 
    A classe possui duas propriedades de manipulador de evento: successHandler e errorHandler. 
    Esses manipuladores são chamados quando a operação de salvamento de imagem é bem-sucedida ou falha, 
    respectivamente.

    A classe possui um método writeToPhotoAlbum que aceita uma imagem UIImage como parâmetro e 
    chama o método estático UIImageWriteToSavedPhotosAlbum da classe UIImage para salvar a imagem no 
    álbum de fotos do usuário. O segundo parâmetro da função é o objeto que implementa o método de 
    retorno de chamada saveCompleted. O terceiro parâmetro é um ponteiro para os dados de contexto 
    opcionais.

    O método saveCompleted é chamado quando a operação de salvamento de imagem é concluída. 
    Ele verifica se houve um erro durante a operação e, se houver, chama o manipulador 
    de erro errorHandler. Caso contrário, ele chama o manipulador de sucesso successHandler.
*/

class ImageSaver: NSObject {

    /*
        NSObject é a classe base em Swift para todas as classes em um aplicativo Cocoa ou Cocoa Touch. 
        Ele fornece uma interface básica para classes que herdam dele, incluindo suporte para métodos 
        de inicialização, comparação de igualdade, cópias e descrições.
    */
    var successHandler: (() -> Void)?
    var errorHandler: ((Error) -> Void)?

    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)

        /*
            UIImageWriteToSavedPhotosAlbum é uma função de Swift que permite que você salve uma 
            imagem para a biblioteca de fotos do usuário. Exemplo:

            import UIKit

            // Obtenha a imagem que deseja salvar de algum lugar
            let image = UIImage(named: "myImage")

            // Salve a imagem na biblioteca de fotos do usuário
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)

            // Esta função será chamada quando a imagem terminar de salvar
            @objc func image(
                _ image: UIImage, 
                didFinishSavingWithError error: Error?, 
                contextInfo: UnsafeRawPointer) {
                    if let error = error {
                        // Ocorreu um erro ao salvar a imagem
                        print("Error saving image: \(error.localizedDescription)")
                    } else {
                        // A imagem foi salva com sucesso
                        print("Image saved successfully")
                    }
            }
            Note que você precisa importar o UIKit framework e fornecer uma função de 
            retorno de chamada para ser chamada quando a imagem tiver terminado de ser salva. 
            Isso é necessário porque o salvamento da imagem é feito de forma assíncrona.
        */
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            errorHandler?(error)
        } else {
            successHandler?()
        }
    }
}

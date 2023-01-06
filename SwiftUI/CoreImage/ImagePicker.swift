import PhotosUI
import SwiftUI

/*
    A struct ImagePicker, que é uma visão controlada SwiftUI que exibe um PHPickerViewController 
    da biblioteca PhotosUI. O PHPickerViewController permite ao usuário selecionar 
    imagens da biblioteca de fotos do dispositivo e retorná-las para o aplicativo.

    A struct ImagePicker possui um tipo de associação chamado Coordenador, 
    que é responsável por lidar com o retorno da imagem selecionada pelo usuário. 
    Quando o usuário seleciona uma imagem e a escolhe, a função picker é chamada no Coordenador. 
    Essa função carrega a imagem selecionada como um objeto UIImage e atribui a 
    imagem ao @Binding var image. Isso permite que a imagem selecionada pelo usuário seja 
    exibida em outro lugar na interface do usuário SwiftUI.

    A struct ImagePicker também implementa os métodos makeUIViewController, updateUIViewController e 
    makeCoordinator, que são exigidos pelo protocolo UIViewControllerRepresentable. 
    Eles permitem que a estrutura ImagePicker seja usada como uma visão controlada em um 
    aplicativo SwiftUI.
*/

struct ImagePicker: UIViewControllerRepresentable {

    /*
        UIViewControllerRepresentable é um protocolo do SwiftUI que permite que você 
        inclua visões controladas do UIKit em sua interface do usuário SwiftUI.

        O UIViewControllerRepresentable exige que você implemente três métodos:

        makeUIViewController(context:): Esse método é chamado quando o SwiftUI precisa criar 
        uma nova instância de seu UIViewController. Você deve criar e configurar um UIViewController 
        neste método e retorná-lo.

        updateUIViewController(_:context:): Esse método é chamado quando o estado de sua visualização 
        SwiftUI muda e o UIViewController precisa ser atualizado. Você pode usar este método para 
        sincronizar o estado do seu UIViewController com o estado da sua visualização SwiftUI.

        uIViewControllerType: Esse é um tipo de alias que você deve definir para o tipo de 
        UIViewController que você está representando.
    */
    @Binding var image: UIImage?

    class Coordinator: NSObject, PHPickerViewControllerDelegate {

        /*
            O PHPickerViewControllerDelegate é um protocolo do iOS 14 que permite que você gerencie 
            um PHPickerViewController, que é uma visualização de seleção de mídia fornecida pelo 
            framework Photos. O PHPickerViewControllerDelegate exige que você implemente um método 
            para ser notificado quando o usuário seleciona um ou mais itens no PHPickerViewController.
        */
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {

            /*
                O PHPickerResult é um tipo de dados fornecido pelo framework Photos do iOS 14 que 
                representa um item selecionado pelo usuário em um PHPickerViewController. 
                Ele contém informações sobre o item selecionado, como o tipo de mídia (foto, vídeo, etc.), 
                a URL de acesso do item e a data de criação do item.
            */
            picker.dismiss(animated: true)

            /*
                first é uma propriedade de coleção do Swift que retorna o primeiro elemento 
                de uma coleção, ou nil se a coleção estiver vazia. Você pode usar a propriedade first 
                em qualquer tipo de coleção que implemente o protocolo "Sequence", 
                como arrays, conjuntos e sequências.
            */
            guard let provider = results.first?.itemProvider else { return }

            /*
                O itemProvider é uma propriedade fornecida pelo framework Photos do iOS 14 
                que permite acessar o conteúdo de um PHPickerResult de forma segura. 
                Ele implementa o protocolo NSItemProvider, que fornece uma interface 
                para ler e escrever diferentes tipos de dados, como imagens, arquivos e strings.
            */

            if provider.canLoadObject(ofClass: UIImage.self) {

                /*
                    canLoadObject é um método do protocolo NSItemProvider do iOS que 
                    permite verificar se um determinado tipo de objeto pode ser carregado a 
                    partir de um itemProvider. Ele é útil quando você deseja tratar casos em que o 
                    conteúdo do itemProvider não pode ser carregado de forma confiável.
                */
                provider.loadObject(ofClass: UIImage.self) { image, _ in

                /*
                    loadObject é um método do protocolo NSItemProvider do iOS que permite carregar o 
                    conteúdo de um itemProvider em um determinado tipo de objeto. Ele é útil quando você 
                    precisa acessar o conteúdo de um itemProvider de forma segura e confiável.
                */
                    self.parent.image = image as? UIImage

                    /*
                        O operador "as?" é um operador de casting do Swift que tenta converter um 
                        valor para um determinado tipo e retorna um valor opcional do tipo desejado. 
                        Se a conversão for bem-sucedida, o valor opcional conterá o valor convertido. 
                        Se a conversão falhar, o valor opcional será nil.
                    */
                }
            }
        }
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()

        /*
            O PHPickerConfiguration é uma classe do framework Photos do iOS 14 que permite configurar 
            as opções de um PHPickerViewController. Você pode usar um objeto PHPickerConfiguration 
            para especificar o tipo de mídia que o usuário pode selecionar, o número máximo de 
            itens que o usuário pode selecionar e outras opções.
        */
        config.filter = .images

        let picker = PHPickerViewController(configuration: config)

        /*
            .delegate é um atributo de algumas classes e protótipos do iOS que permite definir 
            um objeto como um delegado dessa classe ou protótipo. O delegate é um padrão de projeto que 
            permite que você delegue algumas responsabilidades a outro objeto.

            .coordinator é um atributo de algumas classes do Swift que é usado como um intermediário 
            entre essa classe e outras partes do seu aplicativo. Ele é geralmente usado em conjunto 
            com o padrão de projeto "Coordinator", que divide a lógica do seu aplicativo em 
            diferentes coordenadores responsáveis por diferentes tarefas.

            Context é um tipo de dado genérico do SwiftUI que é usado como um contexto para 
            alguns métodos das classes "UIViewRepresentable" e "UIViewControllerRepresentable". 
            Ele é geralmente usado para passar informações entre o aplicativo SwiftUI e o componente 
            UIKit que está sendo representado.
        */
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

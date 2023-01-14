import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

/*
    A struct MeView exibe um formulário com campos de texto para inserir o nome e o endereço de e-mail 
    do usuário e uma imagem QR gerada a partir dessas informações. Quando o usuário insere o nome e o 
    endereço de e-mail no formulário e pressiona o botão de retorno do teclado, o script usa o 
    framework CoreImage para gerar um código QR com base nessas informações e exibe-o na tela. Além disso, 
    o script também permite que o usuário salve a imagem QR gerada em sua biblioteca de fotos. A struct 
    MeView contém três variáveis de estado: name, emailAddress e qrCode, que são usadas para armazenar o 
    nome e o endereço de e-mail inseridos pelo usuário e a imagem QR gerada, respectivamente. Ele usa o 
    filter CIFilter.qrCodeGenerator() para gerar o QR Code.
*/

struct MeView: View {
    @State private var name = "Anonymous"
    @State private var emailAddress = "you@yoursite.com"
    @State private var qrCode = UIImage()

    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()

    /*
        CIFilter.qrCodeGenerator() é um método estático da classe CIFilter do framework CoreImage do iOS 
        que retorna uma instância de CIFilter específica para gerar códigos QR. Ele usa a tecnologia 
        CIQRCodeGenerator para gerar QR codes a partir de uma mensagem de dados. Exemplo:

        let filter = CIFilter.qrCodeGenerator()
        filter.setValue("My message", forKey: "inputMessage")
        filter.setValue("H", forKey: "inputCorrectionLevel")
        let outputImage = filter.outputImage

        Neste exemplo acima, uma instância de CIFilter é criada usando o método qrCodeGenerator(). 
        Em seguida, as propriedades inputMessage e inputCorrectionLevel são configuradas com a mensagem a 
        ser codificada no QR Code e o nível de correção desejado. A propriedade outputImage é então usada 
        para obter a imagem gerada.

        O valor de inputCorrectionLevel pode ser "L", "M", "Q" ou "H", sendo "H" o nível de correção mais 
        alto.
    */

    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                    .textContentType(.name)

                    /*
                        textContentType é uma propriedade do componente TextField no SwiftUI que permite 
                        especificar o tipo de conteúdo que o usuário está esperando inserir no campo de 
                        texto. Ele faz uso da classe UITextContentType do iOS para definir o tipo de 
                        conteúdo, e ajuda o sistema a preencher automaticamente o campo de texto com 
                        informações de contato, endereço, senhas e outras informações do usuário.

                        TextField("Name", text: $name)
                            .textContentType(.name)

                        O campo de texto é configurado para aceitar entradas do tipo "name" (nome), e o 
                        sistema pode preencher automaticamente o campo com o nome do usuário.

                        Algumas opções disponíveis para a propriedade textContentType incluem:

                        .name
                        .emailAddress
                        .telephoneNumber
                        .addressCity
                        .password
                        .newPassword
                        .oneTimeCode

                        Essa propriedade é opcional, e se não for definida o sistema irá usar o tipo de 
                        conteúdo padrão.
                    */

                    .font(.title)

                TextField("Email address", text: $emailAddress)
                    .textContentType(.emailAddress)
                    .font(.title)

                Image(uiImage: qrCode)
                    .resizable()
                    .interpolation(.none)

                    /*
                        interpolation é uma propriedade do componente Image no SwiftUI que permite 
                        especificar o método de interpolação usado para redimensionar ou 
                        redimensionar uma imagem. Ele é usado para ajustar a qualidade da imagem quando é 
                        redimensionada.
                    */

                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .contextMenu {
                        Button {
                            let imageSaver = ImageSaver()
                            imageSaver.writeToPhotoAlbum(image: qrCode)
                        } label: {
                            Label("Save to Photos", systemImage: "square.and.arrow.down")
                        }
                    }
            }
            .navigationTitle("Your code")
            .onAppear(perform: updateCode)

            /*
                onAppear é um modificador de view do SwiftUI que permite especificar uma ação a ser 
                executada quando a view é exibida na tela. Ele é usado para configurar ou atualizar a view 
                antes de ser exibida, ou para iniciar uma animação quando a view é exibida. Exemplo:

                struct MeView: View {
                    @State private var name = "Anonymous"
                    @State private var emailAddress = "you@yoursite.com"
                    @State private var qrCode = UIImage()

                    var body: some View {
                        Form {
                            TextField("Name", text: $name)
                            TextField("Email address", text: $emailAddress)
                            Image(uiImage: qrCode)
                        }
                        .onAppear(perform: updateCode)
                    }

                    func updateCode() {
                        qrCode = generateQRCode(from: "\(name)\n\(emailAddress)")
                    }
                }

                A função updateCode é chamada quando a view é exibida na tela. Isso garante que a imagem 
                QR gerada esteja sempre atualizada com as informações do usuário inseridas nos campos de 
                texto. Além disso, você pode usar o onDisappear para detectar quando a view está saindo de 
                tela, e assim pode fazer algo quando isso acontece. Outra maneira de fazer isso é usando o 
                .onChange para detectar quando o valor de uma determinada propriedade muda, por exemplo:

                .onChange(of: name) { _ in updateCode() }

                Isso faria com que a função updateCode fosse chamada sempre que o valor de name mudasse, 
                garantindo que a imagem QR esteja sempre atualizada. Lembre-se que esses métodos são 
                chamados somente quando a view é exibida na tela, se a view for retirada da tela esses 
                métodos não serão mais chamados. Eles são úteis para configurar a view antes de ser exibida,
                carregar dados, fazer animações, entre outros. Eles também podem ser usados para limpar 
                recursos ou desfazer configurações feitas na view quando ela é removida da tela.
            */

            .onChange(of: name) { _ in updateCode() }
            .onChange(of: emailAddress) { _ in updateCode() }

            /*
                onChange é um modificador de view do SwiftUI que permite especificar uma ação a ser 
                executada quando o valor de uma determinada propriedade é alterado. Ele é usado para 
                detectar mudanças em propriedades que afetam a apresentação da view e atualizar a view 
                automaticamente.

            */
        }
    }

    func updateCode() {
        qrCode = generateQRCode(from: "\(name)\n\(emailAddress)")
    }

    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)

        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        MeView()
    }
}

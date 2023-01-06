import CoreImage

/*
    Core Image é um framework de processamento de imagem incluído no macOS e iOS. 
    Ele fornece uma ampla variedade de filtros e efeitos de imagem que podem ser aplicados a imagens 
    para melhorar ou alterar o seu aspecto. O Core Image é baseado em uma arquitetura de processamento 
    de imagem por pipeline, o que significa que as imagens são processadas por uma série de filtros 
    que são aplicados em sequência. Cada filtro é implementado como um objeto Core Image Filter que 
    pode ser configurado com diferentes parâmetros e, em seguida, aplicado à imagem.
*/

import CoreImage.CIFilterBuiltins

/*
    Core Image.CIFilterBuiltins é uma estrutura no framework Core Image do macOS e iOS que 
    fornece acesso a uma coleção de filtros de imagem pré-definidos. Esses filtros incluem efeitos 
    básicos como blur, colorizar e distorção, bem como filtros mais avançados como morphological 
    gradiente e perfil de colorido.

    Para usar os filtros pré-definidos em Core Image.CIFilterBuiltins no Swift, basta importar o 
    Core Image.CIFilterBuiltins framework e, em seguida, criar uma nova instância do filtro desejado.

    Exemplo:

    let filter = CIFilter.gaussianBlur()

    Em seguida, você pode configurar os parâmetros do filtro e aplicá-lo à imagem desejada.

    let image = CIImage(image: myUIImage)
    filter.setValue(image, forKey: kCIInputImageKey)
    filter.setValue(10, forKey: kCIInputRadiusKey)
    let outputImage = filter.outputImage
*/

import SwiftUI

/*
    O ContentView permite que o usuário selecione uma foto, aplique um filtro de imagem e salve a 
    imagem processada. A aplicação também inclui um slider que permite ao usuário ajustar a intensidade 
    do filtro. Existem vários filtros disponíveis para escolha, incluindo Crystallize, Edges, 
    Gaussian Blur, Pixellate, Sepia Tone, Unsharp Mask e Vignette.

    O ContentView define várias variáveis de estado, incluindo image, filterIntensity, 
    showingImagePicker, inputImage, processedImage, currentFilter e context.

    O corpo da visão é definido como uma instância de NavigationView, que é um componente de i
    nterface do usuário do SwiftUI que fornece uma barra de navegação para a aplicação.
    Dentro da NavigationView, há um VStack que contém vários outros componentes de interface do usuário, 
    incluindo um Rectangle e um Text, que são exibidos enquanto a foto não é selecionada. 
    Quando o usuário toca na tela, é exibido um ImagePicker que permite ao usuário selecionar uma foto.

    Quando uma foto é selecionada, o inputImage é atualizado e o loadImage() método é chamado. 
    O loadImage() método cria uma nova imagem do inputImage e configura a imagem como a entrada para o 
    filtro atual. Em seguida, o applyProcessing() método é chamado para aplicar o filtro à imagem.

    O applyProcessing() método verifica se o filtro atual possui chaves de entrada para a intensidade, 
    raio e escala e, se essas chaves estiverem presentes, ajusta o filtro usando o valor da 
    intensidade atual. Em seguida, o método tenta criar uma imagem resultante usando o 
    contexto de imagem e, se for bem-sucedido, atualiza a image e processedImage variáveis de 
    estado com a imagem resultante.

    O save() método é chamado quando o usuário toca no botão "Save" e tenta salvar a 
    imagem processada no álbum de fotos do usuário. O setFilter() método é chamado quando o 
    usuário toca no botão "Change Filter" e exibe uma folha de seleção de filtro com várias opções de 
    filtro disponíveis. Quando o usuário seleciona um filtro, o currentFilter variável de estado é 
    atualizada com o novo filtro e o applyProcessing() método é chamado novamente para aplicar o 
    novo filtro à imagem.
*/

struct ContentView: View {
    @State private var image: Image?
    @State private var filterIntensity = 0.5

    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?

    @State private var currentFilter: CIFilter = 
    
    /*
        CIFilter.sepiaTone() é uma função do Core Image que cria um novo filtro de tonalidade sépia. 
        O filtro de tonalidade sépia é um efeito de imagem que aplica uma tonalidade marrom acinzentada 
        à imagem, como se fosse uma foto antiga.
    */

    let context = CIContext()

    /*
        CIContext é uma classe do Core Image que permite aos desenvolvedores criar imagens 
        bitmap a partir de objetos CIImage e renderizar essas imagens em diferentes contextos de 
        saída, como uma view ou um arquivo de imagem. Ele também permite aos desenvolvedores 
        aplicar efeitos e filtros de imagem a imagens usando o pipeline de processamento de 
        imagem do Core Image.
    */

    @State private var showingFilterSheet = false

    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(.secondary)

                    Text("Tap to select a picture")
                        .foregroundColor(.white)
                        .font(.headline)

                    image?
                        .resizable()
                        .scaledToFit()
                }
                .onTapGesture {
                    showingImagePicker = true
                }

                HStack {
                    Text("Intensity")
                    Slider(value: $filterIntensity)
                        .onChange(of: filterIntensity) { _ in applyProcessing() }
                }
                .padding(.vertical)

                HStack {
                    Button("Change Filter") {
                        showingFilterSheet = true
                    }

                    Spacer()

                    Button("Save", action: save)
                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Instafilter")
            .onChange(of: inputImage) { _ in loadImage() }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .confirmationDialog("Select a filter", isPresented: $showingFilterSheet) {
                Button("Crystallize") { setFilter(CIFilter.crystallize()) }
                Button("Edges") { setFilter(CIFilter.edges()) }
                Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
                Button("Pixellate") { setFilter(CIFilter.pixellate()) }
                Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
                Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }
                Button("Vignette") { setFilter(CIFilter.vignette()) }
                Button("Cancel", role: .cancel) { }

                /*
                    .confirmationDialog é um método do SwiftUI que exibe um diálogo de confirmação modal 
                    com botões para confirmar ou cancelar a ação. Ele é usado para solicitar confirmação 
                    do usuário antes de prosseguir com uma ação que possa ter consequências.

                    Ao usar o método .confirmationDialog, você pode especificar ações para cada botão do diálogo.


                */
            }
        }
    }

    func loadImage() {
        guard let inputImage = inputImage else { return }


        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }

    func save() {
        guard let processedImage = processedImage else { return }

        let imageSaver = ImageSaver()

        imageSaver.successHandler = {
            print("Success!")
        }

        imageSaver.errorHandler = {
            print("Oops! \($0.localizedDescription)")
        }

        imageSaver.writeToPhotoAlbum(image: processedImage)
    }

    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys

        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(filterIntensity * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey) }

        guard let outputImage = currentFilter.outputImage else { return }

        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
            processedImage = uiImage
        }
    }

    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }
}

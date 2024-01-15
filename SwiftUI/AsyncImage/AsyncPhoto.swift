import SwiftUI

/*
O AsyncPhoto é usado carregar e exibir imagens assincronamente. A visualização 
lida com três fases diferentes: carregamento, sucesso (quando a imagem é 
carregada com sucesso) e um marcador de posição (quando não há dados disponíveis).

O AsyncPhoto aceita vários parâmetros:

id: Identificador único para a imagem.
scaledSize: Tamanho desejado para a imagem.
data: Uma função assíncrona que retorna os dados da imagem.
content: Um bloco de construção para personalizar a aparência da imagem carregada.
progress: Um bloco de construção para personalizar a aparência do indicador de progresso durante o carregamento.
placeholder: Um bloco de construção para personalizar a aparência do marcador de posição.
A função prepareScaledImage é responsável por carregar e preparar a imagem assincronamente.

EX: 

AsyncPhoto(id: "uniqueID",
           scaledSize: CGSize(width: 200, height: 200),
           data: { _ in
               // Função assíncrona que retorna os dados da imagem
               // (pode ser uma chamada de API, download da web, etc.)
               // Retorna, por exemplo, dados de uma imagem preenchida com cor laranja.
               UIImage.filled(size: CGSize(width: 500, height: 500), fillColor: .systemOrange).pngData()
           },
           content: { image in
               // Personalize a aparência da imagem carregada.
               image
                   .resizable()
                   .scaledToFit()
           },
           progress: {
               // Personalize a aparência do indicador de progresso.
               ProgressView()
           },
           placeholder: {
               // Personalize a aparência do marcador de posição.
               Color.secondary
           })

*/

struct AsyncPhoto<ID, Content, Progress, Placeholder>: View where ID: Equatable, Content: View, Progress: View, Placeholder: View {
    @State private var phase: Phase = .loading

    let id: ID
    let data: (ID) async -> Data?
    let scaledSize: CGSize
    @ViewBuilder let content: (Image) -> Content
    @ViewBuilder let placeholder: () -> Placeholder
    @ViewBuilder let progress: () -> Progress

    init(id value: ID = "",
         scaledSize: CGSize,
         data: @escaping (ID) async -> Data?,
         content: @escaping (Image) -> Content,
         progress: @escaping () -> Progress = { ProgressView() },
         placeholder: @escaping () -> Placeholder = { Color.secondary }) {
        self.id = value
        self.content = content
        self.data = data
        self.placeholder = placeholder
        self.progress = progress
        self.scaledSize = scaledSize
    }

    var body: some View {
        VStack {
            switch phase {
            case .success(let image):
                content(image)
            case .loading:
                progress()
            case .placeholder:
                placeholder()
            }
        }
        .frame(width: scaledSize.width, height: scaledSize.height)
        .task(id: id, {
            await self.load()
        })
    }

    @MainActor func load() async {
        phase = .loading
        if let image = await prepareScaledImage() {
            phase = .success(image)
        }
        else {
            phase = .placeholder
        }
    }

    func prepareScaledImage() async -> Image? {
        guard let photoData = await data(id) else { return nil }
        guard let originalImage = UIImage(data: photoData) else { return nil }
        let scaledImage = await originalImage.scaled(toFill: scaledSize)
        guard let finalImage = await scaledImage.byPreparingForDisplay() else { return nil }
        return Image(uiImage: finalImage)
    }
}

extension AsyncPhoto {
    enum Phase {
        case success(Image)
        case loading
        case placeholder
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    return Group {
        AsyncPhoto(id: "",
                   scaledSize: CGSize(width: 64, height: 64),
                   data: { _ in
            UIImage.filled(size: CGSize(width: 500, height: 500), fillColor: .systemOrange).pngData()
        },
                   content: { image in
            image
                .resizable()
                .scaledToFit()
        })
        AsyncPhoto(scaledSize: CGSize(width: 64, height: 64),
                   data: { _ in
            UIImage.filled(size: CGSize(width: 500, height: 500), fillColor: .systemCyan).pngData()
        },
                   content: { image in
            image
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
        })
        AsyncPhoto(scaledSize: CGSize(width: 64, height: 64),
                   data: { _ in nil },
                   content: { $0 })
    }
}

import Foundation
import SwiftUI

/*

Implementação de cache assíncrono para armazenar e recuperar imagens de forma 
eficiente usando o SwiftUI. O código é uma implementação básica de um cache de 
imagens que utiliza a classe NSCache para armazenar imagens em memória.

EX:

// Criar uma instância do AsyncPhotoCache
let photoCache = AsyncPhotoCache.shared

// ID da imagem (pode ser um URL, identificador único, etc.)
let imageID = "exampleImageID"

// Tamanho desejado para a imagem
let imageSize = CGSize(width: 300, height: 200)

// Carregar a imagem do cache
if let cachedImage = photoCache.image(for: imageID, size: imageSize) {
    // Usar a imagem do cache
    // Exemplo: exibir a imagem em uma ImageView
    let imageView = UIImageView(image: cachedImage)
} else {
    // Se a imagem não estiver no cache, carregá-la de alguma fonte externa
    // Exemplo: baixar a imagem de uma URL
    downloadImageFromURL(imageURL) { downloadedImage in
        // Armazenar a imagem no cache
        photoCache.store(downloadedImage, forID: imageID)
        // Usar a imagem baixada
        let imageView = UIImageView(image: downloadedImage)
    }
}

*/
protocol AsyncPhotoCaching {
    func store(_ image: UIImage, forID id: any Hashable)
    func image(for id: any Hashable, size: CGSize) -> UIImage?
    func cacheKey(for id: any Hashable, size: CGSize) -> String
}

extension AsyncPhotoCaching {
    func cacheKey(for id: any Hashable, size: CGSize) -> String {
        "\(id.hashValue):w\(Int(size.width))h\(Int(size.height))"
    }
}

struct AsyncPhotoCache: AsyncPhotoCaching {
    private var storage: NSCache<NSString, UIImage>
    static let shared = AsyncPhotoCache(countLimit: 10)
    
    init(countLimit: Int) {
        self.storage = NSCache()
        self.storage.countLimit = countLimit
    }
    
    func store(_ image: UIImage, forID id: any Hashable) {
        let key = cacheKey(for: id, size: image.size)
        storage.setObject(image, forKey: key as NSString)
    }
    
    func image(for id: any Hashable, size: CGSize) -> UIImage? {
        let key = cacheKey(for: id, size: size)
        return storage.object(forKey: key as NSString)
    }
}

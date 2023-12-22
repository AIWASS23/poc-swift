import UIKit
import CoreGraphics
import Accelerate

/*
Esses métodos encapsulam a lógica para redimensionar a imagem e retornam a nova imagem redimensionada ou nil 
em caso de erro durante o processo de redimensionamento. Esses métodos utilizam diferentes frameworks e APIs 
do iOS para realizar o redimensionamento, proporcionando flexibilidade na escolha da técnica com base nos 
requisitos ou preferências do desenvolvedor.
*/

extension UIImage {

    enum ResizeFramework {
        case uikit
        case coreImage
        case coreGraphics
        case imageIO
        case accelerate
    }
    
    func resizeWithScaleAspectFitMode(
        to dimension: CGFloat, 
        resizeFramework: ResizeFramework = .coreGraphics) -> UIImage? {
            if max(size.width, size.height) <= dimension { return self }
            var newSize: CGSize!
            let aspectRatio = size.width/size.height
            if aspectRatio > 1 {
                newSize = CGSize(width: dimension, height: dimension / aspectRatio)
            } else {
                newSize = CGSize(width: dimension * aspectRatio, height: dimension)
        }
        return resize(to: newSize, with: resizeFramework)
    }
    
    func resize(
        to newSize: CGSize, 
        with resizeFramework: ResizeFramework = .coreGraphics) -> UIImage? {
            switch resizeFramework {
                case .uikit: return resizeWithUIKit(to: newSize)
                case .coreGraphics: return resizeWithCoreGraphics(to: newSize)
                case .coreImage: return resizeWithCoreImage(to: newSize)
                case .imageIO: return resizeWithImageIO(to: newSize)
                case .accelerate: return resizeWithAccelerate(to: newSize)
            }
    }
    
    private func resizeWithUIKit(to newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, true, 1.0)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        defer { UIGraphicsEndImageContext() }
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    private func resizeWithCoreImage(to newSize: CGSize) -> UIImage? {
        guard let cgImage = cgImage, let filter = CIFilter(name: "CILanczosScaleTransform") else { return nil }
        let ciImage = CIImage(cgImage: cgImage)
        let scale = (Double)(newSize.width) / (Double)(ciImage.extent.size.width)
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(NSNumber(value: scale), forKey: kCIInputScaleKey)
        filter.setValue(1.0, forKey: kCIInputAspectRatioKey)
        guard let outputImage = filter.value(forKey: kCIOutputImageKey) as? CIImage else { return nil }
        let context = CIContext(options: [.useSoftwareRenderer: false])
        guard let resultCGImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
        return UIImage(cgImage: resultCGImage)
    }
    
    private func resizeWithCoreGraphics(to newSize: CGSize) -> UIImage? {
        guard let cgImage = cgImage, let colorSpace = cgImage.colorSpace else { return nil }
        let width = Int(newSize.width)
        let height = Int(newSize.height)
        let bitsPerComponent = cgImage.bitsPerComponent
        let bytesPerRow = cgImage.bytesPerRow
        let bitmapInfo = cgImage.bitmapInfo
        guard let context = CGContext(data: nil, width: width, height: height,
                                      bitsPerComponent: bitsPerComponent,
                                      bytesPerRow: bytesPerRow, space: colorSpace,
                                      bitmapInfo: bitmapInfo.rawValue) else { return nil }
        context.interpolationQuality = .high
        let rect = CGRect(origin: CGPoint.zero, size: newSize)
        context.draw(cgImage, in: rect)
        return context.makeImage().flatMap { UIImage(cgImage: $0) }
    }
    
    private func resizeWithImageIO(to newSize: CGSize) -> UIImage? {
        var resultImage = self
        guard let data = jpegData(compressionQuality: 1.0) else { return resultImage }
        let imageCFData = NSData(data: data) as CFData
        let options = [
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: max(newSize.width, newSize.height)
        ] as CFDictionary
        guard   let source = CGImageSourceCreateWithData(imageCFData, nil),
                let imageReference = CGImageSourceCreateThumbnailAtIndex(source, 0, options) else { return resultImage }
        resultImage = UIImage(cgImage: imageReference)
        return resultImage
    }
    
    private func resizeWithAccelerate(to newSize: CGSize) -> UIImage? {
        var resultImage = self
        guard let cgImage = cgImage, let colorSpace = cgImage.colorSpace else { return nil }
        // create a source buffer
        var format = vImage_CGImageFormat(bitsPerComponent: numericCast(cgImage.bitsPerComponent),
                                          bitsPerPixel: numericCast(cgImage.bitsPerPixel),
                                          colorSpace: Unmanaged.passUnretained(colorSpace),
                                          bitmapInfo: cgImage.bitmapInfo,
                                          version: 0,
                                          decode: nil,
                                          renderingIntent: .absoluteColorimetric)
        var sourceBuffer = vImage_Buffer()
        defer {
            sourceBuffer.data.deallocate()
        }
        var error = vImageBuffer_InitWithCGImage(&sourceBuffer, &format, nil, cgImage, numericCast(kvImageNoFlags))
        guard error == kvImageNoError else { return resultImage }
        // create a destination buffer
        let destWidth = Int(newSize.width)
        let destHeight = Int(newSize.height)
        let bytesPerPixel = cgImage.bitsPerPixel
        let destBytesPerRow = destWidth * bytesPerPixel
        let destData = UnsafeMutablePointer<UInt8>.allocate(capacity: destHeight * destBytesPerRow)
        defer {
            destData.deallocate()
        }
        var destBuffer = vImage_Buffer(data: destData,
                                       height: vImagePixelCount(destHeight),
                                       width: vImagePixelCount(destWidth),
                                       rowBytes: destBytesPerRow)
        // scale the image
        error = vImageScale_ARGB8888(&sourceBuffer, &destBuffer, nil, numericCast(kvImageHighQualityResampling))
        guard error == kvImageNoError else { return resultImage }
        // create a CGImage from vImage_Buffer
        let destCGImage = vImageCreateCGImageFromBuffer(&destBuffer, &format, nil, nil,
                                                        numericCast(kvImageNoFlags),
                                                        &error)?.takeRetainedValue()
        guard error == kvImageNoError else { return resultImage }
        // create a UIImage
        if let scaledImage = destCGImage.flatMap({ UIImage(cgImage: $0) }) {
            resultImage = scaledImage
        }
        return resultImage
    }
}

import UIKit
import Photos

extension UIImage {
	
	func imageWith(tintColor: UIColor, blendMode: CGBlendMode = .overlay) -> UIImage? {
		UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
		defer {
			UIGraphicsEndImageContext()
		}
		let canvas = CGRect(origin: .zero, size: size)
		tintColor.setFill()
		UIRectFill(canvas)
		draw(in: canvas, blendMode: blendMode, alpha: 1.0)
		if blendMode != .destinationIn {
			draw(in: canvas, blendMode: .destinationIn, alpha: 1.0)
		}
		return UIGraphicsGetImageFromCurrentImageContext()
		
	}
	
	func scaled(to newSize: CGSize) -> UIImage? {
		let aspectWidth  = newSize.width/size.width
		let aspectHeight = newSize.height/size.height
		let aspectRatio = max(aspectWidth, aspectHeight)
		
		var canvas = CGRect.zero
		canvas.size.width  = size.width * aspectRatio
		canvas.size.height = size.height * aspectRatio
		canvas.origin.x = (newSize.width - size.width * aspectRatio) / 2.0
		canvas.origin.y = (newSize.height - size.height * aspectRatio) / 2.0
		
		UIGraphicsBeginImageContext(newSize)
		defer {
			UIGraphicsEndImageContext()
		}
		draw(in: canvas)
		return UIGraphicsGetImageFromCurrentImageContext()
	}
	
	func saveToPhotoLibrary(completionHandler: @escaping (Bool, Error?) -> Void) {
		PHPhotoLibrary.shared().performChanges {
			PHAssetChangeRequest.creationRequestForAsset(from: self)
		} completionHandler: { result, error in
			DispatchQueue.main.async {
				completionHandler(result, error)
			}
		}
	}
	
	func image(with insets: UIEdgeInsets) -> UIImage {
		UIGraphicsBeginImageContextWithOptions(size + insets, false, scale)
		let origin = CGPoint(x: insets.left, y: insets.top)
		draw(at: origin)
		defer {
			UIGraphicsEndImageContext()
		}
		return UIGraphicsGetImageFromCurrentImageContext().or(self)
	}
	
	static var launchScreenSnapshot: UIImage? {
		guard let infoDict = Bundle.main.infoDictionary else { return .none }
		guard let nameValue = infoDict["UILaunchStoryboardName"] else { return .none }
		guard let name = nameValue as? String else { return .none }
		let storyboard = UIStoryboard(name: name, bundle: .none)
		guard let vc = storyboard.instantiateInitialViewController() else { return .none }
		let screenSize = UIScreen.main.bounds.size
		let screenScale = UIScreen.main.scale
		UIGraphicsBeginImageContextWithOptions(screenSize, false, screenScale)
		guard let context = UIGraphicsGetCurrentContext() else { return .none }
		vc.view.layer.render(in: context)
		return UIGraphicsGetImageFromCurrentImageContext()
	}
	
    var jpegCompressedData: Data? {
        jpegData(compressionQuality: 0.3)
    }
    
	var data: Data? {
		if let data = pngData() {
			return data
		} else if let data = jpegData(compressionQuality: 1) {
			return data
		} else {
			return .none
		}
	}
	
	var roundImage: UIImage? {
		UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
		defer { UIGraphicsEndImageContext() }
		guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
		let rect = CGRect(origin: .zero, size: size)
		ctx.addEllipse(in: rect)
		ctx.clip()
		draw(in: rect)
		return UIGraphicsGetImageFromCurrentImageContext()
	}
	
	func roundImage(clip roundingCorners: UIRectCorner = .allCorners,
					cornerRadii: CGFloat? = nil) -> UIImage? {
		UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
		defer { UIGraphicsEndImageContext() }
		let rect = CGRect(origin: .zero, size: size)
		let defaultRadii = cornerRadii ?? size.height/2
		let cornerSize = CGSize(width: defaultRadii, height: defaultRadii)
		UIBezierPath(roundedRect: rect,
					 byRoundingCorners: roundingCorners,
					 cornerRadii: cornerSize).addClip()
		draw(in: rect)
		return UIGraphicsGetImageFromCurrentImageContext()
	}
}

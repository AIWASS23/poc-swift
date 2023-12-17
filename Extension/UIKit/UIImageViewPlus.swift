import UIKit

extension UIImageView {
	
	func setImageInsets(_ insets: UIEdgeInsets, and image: UIImage?) {
        self.image = image.flatMap { image in
            image.image(with: insets)
        }
	}
}

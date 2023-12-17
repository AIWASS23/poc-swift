import UIKit

extension UIButton {
	
	enum ImagePlacement: Int {
		case top
		case left
		case bottom
		case right
		
		@available(iOS 13.0, *)
		fileprivate var configTranslation: NSDirectionalRectEdge {
			switch self {
			case .top: return .top
			case .left: return .leading
			case .bottom: return .bottom
			case .right: return .trailing
			}
		}
	}
	
	private enum Key {
		static var imagePlacement = UUID()
		static var imagePadding = UUID()
		static var useBackgroundImageSize = UUID()
	}
}

extension UIButton {
	
    convenience init(image: UIImage?) {
        self.init(frame: .zero)
        setImage(image, for: .normal)
    }
    
    convenience init(title: String? = nil, titleColor: UIColor? = nil, titleFontSize: CGFloat = 14.0, titleFontWeight: UIFont.Weight = .regular) {
        let font = UIFont.systemFont(ofSize: titleFontSize, weight: titleFontWeight)
        self.init(title: title, titleColor: titleColor, font: font)
    }
    
    convenience init(title: String? = nil, titleColor: UIColor? = nil, font: UIFont) {
        self.init(frame: .zero)
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        titleLabel?.font = font
    }
    
	open override func setNeedsLayout() {
		super.setNeedsLayout()
		setupImageTitleEdgeInsets()
	}
	
	var useBackgroundImageSize: Bool {
		get { getAssociatedObject(self, &Key.useBackgroundImageSize) as? Bool ?? false }
		set {
			setAssociatedObject(self, &Key.useBackgroundImageSize, newValue, .OBJC_ASSOCIATION_ASSIGN)
			invalidateIntrinsicContentSize()
		}
	}
	
	var imagePlacement: ImagePlacement {
		get {
			guard let rawValue = getAssociatedObject(self, &Key.imagePlacement) as? Int else {
				return .left
			}
			return ImagePlacement(rawValue: rawValue).unsafelyUnwrapped
		}
		set {
			setAssociatedObject(self, &Key.imagePlacement, newValue.rawValue, .OBJC_ASSOCIATION_ASSIGN)
			setupImageTitleEdgeInsets()
		}
	}
	
	var imagePadding: CGFloat {
		get { getAssociatedObject(self, &Key.imagePadding) as? CGFloat ?? 0 }
		set {
			assert(newValue >= 0, "A sane person will never do that🤪,right?")
			setAssociatedObject(self, &Key.imagePadding, newValue, .OBJC_ASSOCIATION_ASSIGN)
			setupImageTitleEdgeInsets()
		}
	}
	
	var backgroundImageView: UIImageView? {
		subviews
			.compactMap { $0 as? UIImageView }
			.first {
				$0.image == currentBackgroundImage
			}
	}
	
	var titleFont: UIFont? {
		get { titleLabel?.font }
		set {
			guard let font = newValue else { return }
			titleLabel?.font = font
		}
	}
	
	var imageSize: CGSize { currentImage?.size ?? .zero }
	var titleSize: CGSize {
		guard let titleLabel = titleLabel, titleLabel.text != .none else {
			return .zero
		}
		let additionalWidth = UIAccessibility.isBoldTextEnabled ? 1.5 : 0
		let additionalSize = CGSize(width: additionalWidth, height: 0)
		return titleLabel.intrinsicContentSize + additionalSize
	}
	var imageWidth: CGFloat { imageSize.width }
	var imageHeight: CGFloat { imageSize.height }
	var titleWidth: CGFloat { titleSize.width }
	var titleHeight: CGFloat { titleSize.height }
	
	open override var intrinsicContentSize: CGSize {

		let backgroundImageSize = currentBackgroundImage?.size ?? .zero
		var regularSize: CGSize {
			if imageSize == .zero {
				return titleSize + contentEdgeInsets
			} else if titleSize == .zero {
				return imageSize + contentEdgeInsets
			} else {
				var size = CGSize.zero
				switch imagePlacement  {
				case .top, .bottom:
					size.width = max(imageWidth, titleWidth)
					size.height = imageHeight + imagePadding + titleHeight
				case .left, .right:
					size.width = imageWidth + imagePadding + titleWidth
					size.height = max(imageHeight, titleHeight)
				}
				return size + contentEdgeInsets
			}
		}

		return useBackgroundImageSize ? backgroundImageSize : regularSize
	}
	
	private func setupImageTitleEdgeInsets() {
		defer {
			invalidateIntrinsicContentSize()
		}
		guard imageSize != .zero && titleSize != .zero else { return }
		
		var imageInsets = UIEdgeInsets.zero
		var titleInsets = UIEdgeInsets.zero
		let halfPadding = imagePadding / 2.0
		
		var alignments = (contentVerticalAlignment, contentHorizontalAlignment)
		if #available(iOS 11, *) {
			alignments = (contentVerticalAlignment, effectiveContentHorizontalAlignment)
		}
		let titleHeightWithPadding = titleHeight + imagePadding
		let titleWidthWithPadding = titleWidth + imagePadding
		let imageHeightWithPadding = imageHeight + imagePadding
		let imageWidthWithPadding = imageWidth + imagePadding
		
		let vOffset = abs(imageHeight - titleHeight) / 2.0
		let hOffset = abs(imageWidth - titleWidth) / 2.0
		var imageHOffset: CGFloat { titleWidth > imageWidth ? hOffset : 0 }
		var imageVOffset: CGFloat { titleHeight > imageHeight ? vOffset : 0 }
		var titleHOffset: CGFloat { imageWidth > titleWidth ? hOffset : 0 }
		var titleVOffset: CGFloat { imageHeight > titleHeight ? vOffset : 0 }
		
		switch alignments {
			
		case (.center, .center):
			switch imagePlacement {
			case .top:
				imageInsets = UIEdgeInsets(top: -titleHeightWithPadding, left: 0, bottom: 0, right: -titleWidth)
				titleInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: -imageHeightWithPadding, right: 0)
			case .left:
				imageInsets = UIEdgeInsets(top: 0, left: -halfPadding, bottom: 0, right: halfPadding)
				titleInsets = UIEdgeInsets(top: 0, left: halfPadding, bottom: 0, right: -halfPadding)
			case .bottom:
				imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -titleHeightWithPadding, right: -titleWidth)
				titleInsets = UIEdgeInsets(top: -imageHeightWithPadding, left: -imageWidth, bottom: 0, right: 0)
			case .right:
				let imageOffset = titleWidth + halfPadding
				let titleOffset = imageWidth + halfPadding
				imageInsets = UIEdgeInsets(top: 0, left: imageOffset, bottom: 0, right: -imageOffset)
				titleInsets = UIEdgeInsets(top: 0, left: -titleOffset, bottom: 0, right: titleOffset)
			}
		case (.center, .left):
			switch imagePlacement {
			case .top:
				imageInsets = UIEdgeInsets(top: -titleHeightWithPadding, left: imageHOffset, bottom: 0, right: 0)
				titleInsets = UIEdgeInsets(top: 0, left: -imageWidth + titleHOffset, bottom: -imageHeightWithPadding, right: -titleHOffset)
			case .left:
				titleInsets = UIEdgeInsets(top: 0, left: imagePadding, bottom: 0, right: -imagePadding)
			case .bottom:
				imageInsets = UIEdgeInsets(top: 0, left: imageHOffset, bottom: -titleHeightWithPadding, right: -titleWidth)
				titleInsets = UIEdgeInsets(top: -imageHeightWithPadding, left: -imageWidth + titleHOffset, bottom: 0, right: 0)
			case .right:
				imageInsets = UIEdgeInsets(top: 0, left: titleWidthWithPadding, bottom: 0, right: -titleWidthWithPadding)
				titleInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: 0, right: imageWidth)
			}
		case (.center, .right):
			switch imagePlacement {
			case .top:
				imageInsets = UIEdgeInsets(top: -titleHeightWithPadding, left: 0, bottom: 0, right: -titleWidth + imageHOffset)
				titleInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: -imageHeightWithPadding, right: titleHOffset)
			case .left:
				imageInsets = UIEdgeInsets(top: 0, left: -imagePadding, bottom: 0, right: imagePadding)
			case .bottom:
				imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -titleHeightWithPadding, right: -titleWidth + imageHOffset)
				titleInsets = UIEdgeInsets(top: -imageHeightWithPadding, left: -imageWidth, bottom: 0, right: titleHOffset)
			case .right:
				imageInsets = UIEdgeInsets(top: 0, left: titleWidth, bottom: 0, right: -titleWidth)
				titleInsets = UIEdgeInsets(top: 0, left: -imageWidthWithPadding, bottom: 0, right: imageWidthWithPadding)
			}
		case (.top, .left):
			switch imagePlacement {
			case .top:
				imageInsets = UIEdgeInsets(top: 0, left: imageHOffset, bottom: 0, right: 0)
				titleInsets = UIEdgeInsets(top: imageHeightWithPadding, left: -imageWidth + titleHOffset, bottom: 0, right: 0)
			case .left:
				imageInsets = UIEdgeInsets(top: imageVOffset, left: 0, bottom: 0, right: 0)
				titleInsets = UIEdgeInsets(top: titleVOffset, left: imagePadding, bottom: 0, right: -imagePadding)
			case .bottom:
				imageInsets = UIEdgeInsets(top: titleHeightWithPadding, left: imageHOffset, bottom: -titleHeightWithPadding, right: 0)
				titleInsets = UIEdgeInsets(top: 0, left: -imageWidth + titleHOffset, bottom: 0, right: 0)
			case .right:
				imageInsets = UIEdgeInsets(top: imageVOffset, left: titleWidthWithPadding, bottom: 0, right: -titleWidthWithPadding)
				titleInsets = UIEdgeInsets(top: titleVOffset, left: -imageWidth, bottom: 0, right: 0)
			}
		case (.top, .center):
			switch imagePlacement {
			case .top:
				imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleWidth)
				titleInsets = UIEdgeInsets(top: imageHeightWithPadding, left: -imageWidth, bottom: 0, right: 0)
			case .left:
				imageInsets = UIEdgeInsets(top: imageVOffset, left: -halfPadding, bottom: 0, right: halfPadding)
				titleInsets = UIEdgeInsets(top: titleVOffset, left: halfPadding, bottom: 0, right: -halfPadding)
			case .bottom:
				imageInsets = UIEdgeInsets(top: titleHeightWithPadding, left: 0, bottom: -titleHeightWithPadding, right: -titleWidth)
				titleInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: 0, right: 0)
			case .right:
				let imageOffset = titleWidth + halfPadding
				let titleOffset = imageWidth + halfPadding
				imageInsets = UIEdgeInsets(top: imageVOffset, left: imageOffset, bottom: 0, right: -imageOffset)
				titleInsets = UIEdgeInsets(top: titleVOffset, left: -titleOffset, bottom: 0, right: titleOffset)
			}
		case (.top, .right):
			switch imagePlacement {
			case .top:
				imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleWidth + imageHOffset)
				titleInsets = UIEdgeInsets(top: imageHeightWithPadding, left: -imageWidthWithPadding, bottom: 0, right: titleHOffset)
			case .left:
				imageInsets = UIEdgeInsets(top: imageVOffset, left: -imagePadding, bottom: 0, right: imagePadding)
				titleInsets = UIEdgeInsets(top: titleVOffset, left: 0, bottom: 0, right: 0)
			case .bottom:
				imageInsets = UIEdgeInsets(top: titleHeightWithPadding, left: 0, bottom: -titleHeightWithPadding, right: -titleWidth + imageHOffset)
				titleInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: 0, right: titleHOffset)
			case .right:
				imageInsets = UIEdgeInsets(top: imageVOffset, left: titleWidth, bottom: 0, right: -titleWidth)
				titleInsets = UIEdgeInsets(top: titleVOffset, left: -imageWidthWithPadding, bottom: 0, right: imageWidthWithPadding)
			}
		case (.bottom, .left):
			switch imagePlacement {
			case .top:
				imageInsets = UIEdgeInsets(top: -titleHeightWithPadding, left: imageHOffset, bottom: titleHeightWithPadding, right: 0)
				titleInsets = UIEdgeInsets(top: 0, left: -imageWidth + titleHOffset, bottom: 0, right: 0)
			case .left:
				imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: imageVOffset, right: 0)
				titleInsets = UIEdgeInsets(top: 0, left: imagePadding, bottom: titleVOffset, right: -imagePadding)
			case .bottom:
				imageInsets = UIEdgeInsets(top: 0, left: imageHOffset, bottom: 0, right: 0)
				titleInsets = UIEdgeInsets(top: 0, left: -imageWidth + titleHOffset, bottom: imageHeightWithPadding, right: 0)
			case .right:
				imageInsets = UIEdgeInsets(top: 0, left: titleWidthWithPadding, bottom: imageVOffset, right: -titleWidthWithPadding)
				titleInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: titleVOffset, right: imageWidth)
			}
		case (.bottom, .center):
			switch imagePlacement {
			case .top:
				imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: titleHeightWithPadding, right: -titleWidth)
				titleInsets = UIEdgeInsets(top: imageHeightWithPadding, left: -imageWidth, bottom: 0, right: 0)
			case .left:
				imageInsets = UIEdgeInsets(top: 0, left: -halfPadding, bottom: imageVOffset, right: halfPadding)
				titleInsets = UIEdgeInsets(top: 0, left: halfPadding, bottom: titleVOffset, right: -halfPadding)
			case .bottom:
				imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleWidth)
				titleInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: imageHeightWithPadding, right: 0)
			case .right:
				let imageOffset = titleWidth + halfPadding
				let titleOffset = imageWidth + halfPadding
				imageInsets = UIEdgeInsets(top: 0, left: imageOffset, bottom: imageVOffset, right: -imageOffset)
				titleInsets = UIEdgeInsets(top: 0, left: -titleOffset, bottom: titleVOffset, right: titleOffset)
			}
		case (.bottom, .right):
			switch imagePlacement {
			case .top:
				imageInsets = UIEdgeInsets(top: -titleHeightWithPadding, left: 0, bottom: titleHeightWithPadding, right: -titleWidth + imageHOffset)
				titleInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: 0, right: titleHOffset)
			case .left:
				imageInsets = UIEdgeInsets(top: 0, left: -imagePadding, bottom: imageVOffset, right: imagePadding)
				titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: titleVOffset, right: 0)
			case .bottom:
				imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleWidth + imageHOffset)
				titleInsets = UIEdgeInsets(top: -imageHeightWithPadding, left: -imageWidth, bottom: imageHeightWithPadding, right: titleHOffset)
			case .right:
				imageInsets = UIEdgeInsets(top: 0, left: titleWidth, bottom: imageVOffset, right: -titleWidth)
				titleInsets = UIEdgeInsets(top: 0, left: -imageWidthWithPadding, bottom: titleVOffset, right: imageWidthWithPadding)
			}
		default:
			break
		}
		
		imageEdgeInsets = imageInsets
		titleEdgeInsets = titleInsets
	}
	
	@available(iOS 15.0, *)
	private func setConfigurationUpdateHandlerIfNeeded() {
		if configuration != nil, configurationUpdateHandler == nil {
			configurationUpdateHandler = { button in
				var config = button.configuration ?? .plain()
				config.contentInsets = button.contentEdgeInsets.directionalEdgeInsets
				config.imagePadding = button.imagePadding
				config.imagePlacement = button.imagePlacement.configTranslation
				if let title = button.title(for: button.state) {
					var titleAttributes = AttributeContainer()
					titleAttributes.font = button.titleLabel?.font
					titleAttributes.foregroundColor = button.titleColor(for: button.state)
					config.attributedTitle = AttributedString(title, attributes: titleAttributes)
				}
				if let attributedTitle = button.attributedTitle(for: button.state) {
					config.attributedTitle = AttributedString(attributedTitle)
				}
				config.image = button.image(for: button.state)
				config.background.image = button.backgroundImage(for: button.state)
				config.background.backgroundColor = button.backgroundColor
				config.baseBackgroundColor = button.backgroundColor
				
				button.configuration = config
			}
		}
		setNeedsUpdateConfiguration()
	}
}

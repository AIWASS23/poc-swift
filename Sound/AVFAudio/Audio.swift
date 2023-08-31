import UIKit

class AudiobookView: UIView {

    let mainViewVStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.backgroundColor = .background
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    let bookCover: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "aSundayAfternoonOnTheIslandOfLaGrandeJatte")
        imageView.tintColor = .text
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isAccessibilityElement = false
        return imageView
    }()

    let audioControls: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.25
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let buttonsHStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    let playBackwardButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        button.contentMode = .scaleAspectFill
        configuration.baseForegroundColor = UIColor.textColor
        configuration.image = UIImage(systemName: "gobackward.10", withConfiguration: UIImage.sideButtonSize)
        button.configuration = configuration
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let pausePlayButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = UIColor.text
        configuration.image = UIImage(systemName: "play.circle.fill", withConfiguration: UIImage.playButtonSize)
        button.configuration = configuration
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let playForwardButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        button.contentMode = .scaleAspectFill
        configuration.baseForegroundColor = UIColor.text
        configuration.image = UIImage(systemName: "goforward.10", withConfiguration: UIImage.sideButtonSize)
        button.configuration = configuration
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let playbackStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
//        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    let timeStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.distribution = .equalCentering
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isAccessibilityElement = false
        return stack
    }()

    let sliderControl: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0.0
        slider.isContinuous = false
        slider.backgroundColor = .clear
        slider.tintColor = UIColor.text
        //        slider.thumbTintColor = UIColor(red: 106/255, green: 90/255, blue: 101/255, alpha: 1)
        slider.thumbTintColor = .text
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.accessibilityTraits = .adjustable
        slider.accessibilityLabel = String(localized: "audio position")
        return slider
    }()

    let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textAlignment = .center
        label.textColor = .text
        label.isAccessibilityElement = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let durationLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textAlignment = .center
        label.textColor = .text
        label.isAccessibilityElement = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.background
        buildLayoutView()

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension AudiobookView: SettingViews {

    func setupSubviews() {

        addSubview(bookCover)
        addSubview(audioControls)

        audioControls.addSubview(buttonsHStack)
        audioControls.addSubview(playbackStack)

        buttonsHStack.addArrangedSubview(playBackwardButton)
        buttonsHStack.addArrangedSubview(pausePlayButton)
        buttonsHStack.addArrangedSubview(playForwardButton)

        playbackStack.addArrangedSubview(sliderControl)
        playbackStack.addArrangedSubview(timeStack)

        timeStack.addArrangedSubview(currentTimeLabel)
        timeStack.addArrangedSubview(durationLabel)
    }

    func setupConstraints() {

        self.layoutIfNeeded()
        NSLayoutConstraint.activate([

            bookCover.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            bookCover.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            bookCover.bottomAnchor.constraint(lessThanOrEqualTo: self.audioControls.topAnchor, constant: -24),
            bookCover.centerXAnchor.constraint(equalTo: centerXAnchor),

            audioControls.heightAnchor.constraint(greaterThanOrEqualTo: self.heightAnchor, multiplier: 0.25),
            audioControls.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            audioControls.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            audioControls.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            buttonsHStack.centerXAnchor.constraint(equalTo: self.audioControls.centerXAnchor),
            buttonsHStack.topAnchor.constraint(equalTo: self.audioControls.topAnchor, constant: 12),

            playbackStack.topAnchor.constraint(equalTo: self.buttonsHStack.bottomAnchor, constant: 12),
            playbackStack.centerXAnchor.constraint(equalTo: self.audioControls.centerXAnchor),
            playbackStack.bottomAnchor.constraint(lessThanOrEqualTo: self.audioControls.safeAreaLayoutGuide.bottomAnchor, constant: -12),

            sliderControl.widthAnchor.constraint(equalTo: self.audioControls.widthAnchor, multiplier: 0.9)
        ])
        self.layoutIfNeeded()
    }
}
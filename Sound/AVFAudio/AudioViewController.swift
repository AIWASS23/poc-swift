import UIKit
import AVFAudio

class AudiobookViewController: UIViewController {
    let audiobookView = AudiobookView()
    var viewModel: AudioBookViewModel = AudioBookViewModel()

    var audioName = "bensound-slider"
    var audioType = "mp3"

    override func viewDidLoad() {
        super.viewDidLoad()
        view = audiobookView
        navigationItem.title = viewModel.getAudioBookTitle()
        navigationItem.largeTitleDisplayMode = .never

        setupAudio()
        AudioManager.shared.player?.delegate = self
        audioName = viewModel.getAudioBookAudioName()
        audiobookView.bookCover.image = UIImage(named: viewModel.getAudioBookImageName())

    }
    override func viewDidLayoutSubviews() {
        setupUI()
        setupAccessibility()
    }

    override func viewDidDisappear(_ animated: Bool) {
        viewModel.stopAudio()
    }

    func setupUI() {
        audiobookView.pausePlayButton.addTarget(self, action: #selector(pausePlayAudio), for: .touchUpInside)
        audiobookView.sliderControl.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        audiobookView.sliderControl.addTarget(self, action: #selector(sliderDrag), for: .touchDragInside)
        audiobookView.playBackwardButton.addTarget(self, action: #selector(audioRewind), for: .touchUpInside)
        audiobookView.playForwardButton.addTarget(self, action: #selector(audioForward), for: .touchUpInside)
    }
    func setupDuration() {
        guard let player = AudioManager.shared.player else { return }
        audiobookView.sliderControl.maximumValue = Float(player.duration)
        viewModel.durationInMinutes(audiobookView.durationLabel)
    }
    func setupAudio() {
        viewModel.soundEnabling()
        AudioManager.shared.prepareToPlay(audioName: viewModel.getAudioBookAudioName(), audioType: audioType)
        viewModel.updateButtonIcon(audiobookView.pausePlayButton)
        setupDuration()
        viewModel.updateSlider(slider: audiobookView.sliderControl, label: audiobookView.currentTimeLabel)
    }
    func setupAccessibility() {
        viewModel.accessibilityTime(slider: audiobookView.sliderControl)
    }
    @objc func pausePlayAudio(_ sender: UIButton) {
        viewModel.togglePlayback()
        viewModel.updateButtonIcon(audiobookView.pausePlayButton)

    }
    @objc func sliderValueChanged(_ sender: UISlider) {
        viewModel.updateSliderValue(sender.value)
        viewModel.accessibilityTime(slider: audiobookView.sliderControl)
    }
    @objc func sliderDrag(_ sender: UISlider) {
        viewModel.seekToTime(Double(sender.value))
    }
    @objc func audioRewind(_ sender: UIButton) {
        viewModel.rewindTime()
    }
    @objc func audioForward(_ sender: UIButton) {
        viewModel.forwardTime()
    }
}

extension AudiobookViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        viewModel.isPlaying = !flag
        viewModel.updateButtonIcon(audiobookView.pausePlayButton)
    }
}
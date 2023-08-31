import UIKit
import AVFoundation

// MARK: - Properties
class AudioBookViewModel {
    private var audioBook: AudioBook?
    private var audioManager = AudioManager.shared
    private var player: AVAudioPlayer? {
        return audioManager.player
    }
//    private var player: AVAudioPlayer? = AudioManager.shared.player
    var isPlaying: Bool = false
    var timer: Timer?

    init(audioBook: AudioBook? = nil) {
        self.audioBook = audioBook
    }

// MARK: - Public Methods
    func setAudioBook(_ audioBook: AudioBook) {
        self.audioBook = audioBook
    }

    func getAudioBookTitle() -> String {
        return audioBook!.title
    }

    func getAudioBookImageName() -> String {
        return audioBook!.image
    }

    func getAudioBookAudioName() -> String {
        return audioBook!.audioName
    }

    func playAudio() {
        player?.play()
        isPlaying = true
    }

    func togglePlayback() {
        if player?.isPlaying == true {
            player?.pause()
            isPlaying = false
        } else {
            player?.play()
            isPlaying = true
        }
    }

    func stopAudio() {
        player?.stop()
        isPlaying = false
    }

    func updateSliderValue(_ value: Float) {
        player?.currentTime = TimeInterval(value)
    }

    func seekToTime(_ time: Double) {
        player?.currentTime = time
    }

    func soundEnabling() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch {
            // Celular pode estar no silencioso
            print("Checar se o celular está no silencioso")
        }
    }

    func updateButtonIcon(_ button: UIButton) {
        let icon = isPlaying ? "pause.circle.fill"  : "play.circle.fill"
        button.configuration?.image = UIImage(systemName: icon, withConfiguration: UIImage.playButtonSize)
    }

    func durationInMinutes(_ label: UILabel) {
        guard let player =  AudioManager.shared.player else { return }
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad

        let timeInterval = TimeInterval(player.duration)
        if let formattedString = formatter.string(from: timeInterval) {
            label.text = formattedString
        }
    }

    func currentTimeMinutes(_ label: UILabel) {
        guard let player =  AudioManager.shared.player else { return }

        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad

        if let formattedString = formatter.string(from: TimeInterval(player.currentTime)) {
            label.text = formattedString
        }
    }

    func updateTimeLabel(with currentTime: Float, duration: Float, in label: UILabel) {
        let currentMinutes = Int(currentTime / 60)
        let currentSeconds = Int(currentTime.truncatingRemainder(dividingBy: 60))
        let timeText = String(format: "%02d:%02d", currentMinutes, currentSeconds)
        label.text = timeText
    }

    func rewindTime() {
        let time = 10
        player?.currentTime -= Double(time)
    }

    func forwardTime() {
        let time = 10
        player?.currentTime += Double(time)
    }

    func updateSlider(slider: UISlider, label: UILabel) {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            guard let player = AudioManager.shared.player else { return }
            let currentTime = Float(player.currentTime)
            slider.value = currentTime
            self.updateTimeLabel(with: currentTime, duration: Float(player.duration), in: label)
        }
    }

    func accessibilityTime(slider: UISlider) {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .spellOut

        guard let player = AudioManager.shared.player else { return }
        if let formattedTimeString = formatter.string(from: TimeInterval(player.currentTime)),
           let formattedFullString = formatter.string(from: TimeInterval(player.duration)) {
            slider.accessibilityValue = String.localizedStringWithFormat(
                NSLocalizedString("%@! of %@!",
                                  comment: ""),
                formattedTimeString,
                formattedFullString
            )
        }
    }
}
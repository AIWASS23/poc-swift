import Foundation
import AVKit

class AudioManager {

    static let shared = AudioManager()

    var player: AVAudioPlayer?

    func prepareToPlay(audioName: String, audioType: String) {
        guard let audioURL = Bundle.main.url(forResource: audioName, withExtension: audioType) else { return }
        do {
            player = try AVAudioPlayer(contentsOf: audioURL)
            player?.prepareToPlay()
        } catch {
            print(error.localizedDescription)
        }
    }

    private init(player: AVAudioPlayer? = nil) {
        self.player = player
    }
}
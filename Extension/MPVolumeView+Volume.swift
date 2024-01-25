import Foundation
import MediaPlayer

/*
A extensão adiciona um método estático chamado setVolume(_:), o qual permite definir o nível de volume do dispositivo através de um controle deslizante.
*/

extension MPVolumeView {
    static func setVolume(_ volume: Float) {
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            slider?.value = volume
        }
    }
}

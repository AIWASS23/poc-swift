import AVFoundation

enum OpenClose {
    case open
    case close
}

func openCloseSound(openClose: OpenClose) {
    AudioServicesPlaySystemSound(openClose == .open ? 1100 : 1100)
}

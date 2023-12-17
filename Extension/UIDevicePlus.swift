import UIKit
import AVFoundation

/*
A finalidade da extension para as classes UIDevice, UIDeviceOrientation e 
UIInterfaceOrientation é oferecer funcionalidades adicionais e facilitar o acesso a 
informações relacionadas ao dispositivo, à orientação da tela e à disponibilidade da 
câmera.

EX:
// Verificar se a câmera está disponível no dispositivo
if UIDevice.isCameraAvailable {
    print("A câmera está disponível!")
} else {
    print("A câmera não está disponível neste dispositivo.")
}

// Verificar se a câmera frontal está disponível
if UIDevice.isFrontCameraAvailable {
    print("A câmera frontal está disponível!")
} else {
    print("A câmera frontal não está disponível neste dispositivo.")
}

// Verificar se a câmera traseira está disponível
if UIDevice.isRearCameraAvailable {
    print("A câmera traseira está disponível!")
} else {
    print("A câmera traseira não está disponível neste dispositivo.")
}

// Obter o modelo do dispositivo
let deviceModel = UIDevice.modelName
print("Modelo do dispositivo: \(deviceModel)")

// Verificar se a orientação atual da tela é regular (retrato ou paisagem)
let currentOrientation = UIDeviceOrientation.current
if currentOrientation.isRegularOrientation {
    print("A orientação atual é regular.")
} else {
    print("A orientação atual não é regular.")
}

// Obter a orientação regular da tela para captura de vídeo
let captureOrientation = UIDeviceOrientation.current.captureVideoOrientation
print("Orientação para captura de vídeo: \(captureOrientation.rawValue)")

// Verificar se a tela está no modo retrato
if UIDeviceOrientation.current.isScreenPortrait {
    print("A tela está no modo retrato.")
} else {
    print("A tela não está no modo retrato.")
}

// Verificar se a tela está no modo paisagem
if UIDeviceOrientation.current.isScreenLandscape {
    print("A tela está no modo paisagem.")
} else {
    print("A tela não está no modo paisagem.")
}

*/

extension UIDevice {
    
    static var isCameraAvailable: Bool {
        UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    static var isFrontCameraAvailable: Bool {
        UIImagePickerController.isCameraDeviceAvailable(.front)
    }
    
    static var isRearCameraAvailable: Bool {
        UIImagePickerController.isCameraDeviceAvailable(.rear)
    }
    
    static var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}

extension UIDeviceOrientation {
    
    var isRegularOrientation: Bool {
        switch self {
        case .portrait, .portraitUpsideDown, .landscapeLeft, .landscapeRight:
            true
        default:
            false
        }
    }

    var regularOrientation: UIDeviceOrientation {
        lazy var defaultRegularOrientation = UIDeviceOrientation.landscapeLeft
        if isRegularOrientation {
            return self
        } else {
            if #available(iOS 13.0, *) {
                if let window = UIApplication.shared.windows.first {
                    if let windowScene = window.windowScene {
                        return windowScene.interfaceOrientation.regularDeviceOrientation
                    } else {
                        return defaultRegularOrientation
                    }
                } else {
                    return defaultRegularOrientation
                }
            } else {
                return UIApplication.shared.statusBarOrientation.regularDeviceOrientation
            }
        }
    }
    
    var captureVideoOrientation: AVCaptureVideoOrientation {
        switch regularOrientation {
        case .portrait:
            return .portrait
        case .portraitUpsideDown:
            return .portraitUpsideDown
        case .landscapeLeft:
            return .landscapeRight
        case .landscapeRight:
            return .landscapeLeft
        default:
            fatalError("Should not happen.")
        }
    }
    
    var isScreenPortrait: Bool {
        !isScreenLandscape
    }
    
    var isScreenLandscape: Bool {
        lazy var isLandscape = UIScreen.main.bounds.size.isLandscape
        if #available(iOS 13.0, *) {
            if let window = UIApplication.shared.windows.first {
                if let windowScene = window.windowScene {
                    return windowScene.interfaceOrientation.isScreenLandscape
                } else {
                    return isLandscape
                }
            } else {
                return isLandscape
            }
        } else {
            return UIApplication.shared.statusBarOrientation.isScreenLandscape
        }
    }
}

extension UIInterfaceOrientation {
    
    var isScreenLandscape: Bool {
        switch self {
        case .unknown:
            return UIScreen.main.bounds.size.isLandscape
        default:
            return isLandscape
        }
    }
    
    var regularDeviceOrientation: UIDeviceOrientation {
        lazy var defaultRegularOrientation = UIDeviceOrientation.landscapeLeft
        switch self {
        case .unknown:
            dprint("未知朝向")
            return defaultRegularOrientation
        case .portrait:
            return .portrait
        case .portraitUpsideDown:
            return .portraitUpsideDown
        case .landscapeLeft: 
            return .landscapeRight 
        case .landscapeRight: 
            return .landscapeLeft 
        @unknown default:
            assertionFailure("Unhandled condition")
            return defaultRegularOrientation
        }
    }
}

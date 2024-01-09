import SwiftUI

@available(iOS 13.0, *)
extension View {
   
    func iOS(_ modifer: (Self) -> some View) -> some View {
        return applyModifierIfNeeded(modifer, for: .phone)
    }

    func iPadOS(_ modifer: (Self) -> some View) -> some View {
        return applyModifierIfNeeded(modifer, for: .pad)
    }

    @available(iOS 14.0, *)
    func macOS(_ modifer: (Self) -> some View) -> some View {
        return applyModifierIfNeeded(modifer, for: .mac)
    }

    func tvOS(_ modifer: (Self) -> some View) -> some View {
        return applyModifierIfNeeded(modifer, for: .tv)
    }

    func carPlay(_ modifer: (Self) -> some View) -> some View {
        return applyModifierIfNeeded(modifer, for: .carPlay)
    }

    @available(iOS 17.0, *)
    func vision(_ modifer: (Self) -> some View) -> some View {
        return applyModifierIfNeeded(modifer, for: .vision)
    }

    private func applyModifierIfNeeded(_ modifer: (Self) -> some View, for idiom: UIUserInterfaceIdiom) -> some View {
        if UIDevice.current.userInterfaceIdiom == idiom {
            return AnyView(modifer(self))
        }
        return AnyView(self)
    }
}

/*
Os métodos oferecem uma maneira conveniente de aplicar diferentes modificações de visualização com base no 
tipo de dispositivo em execução, permitindo que o aplicativo adapte sua interface de usuário para atender a 
diferentes dispositivos de forma específica.

exemplo de uso:

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Welcome to SwiftUI")
                .iOS { $0.font(.title) } // Aplica fonte de título se executando em um iPhone

            Text("Hello, iPad!")
                .iPadOS { $0.font(.largeTitle).foregroundColor(.blue) } // Aplica estilo específico para iPad

            Text("macOS App")
                .macOS { $0.font(.title).foregroundColor(.green) } // Aplica estilo específico para macOS (disponível a partir do iOS 14.0)
            
            Text("Apple TV")
                .tvOS { $0.font(.title).foregroundColor(.orange) } // Aplica estilo específico para Apple TV

            Text("CarPlay")
                .carPlay { $0.font(.title).foregroundColor(.red) } // Aplica estilo específico para CarPlay

            Text("Vision Framework")
                .vision { $0.font(.title).foregroundColor(.purple) } // Aplica estilo específico para dispositivos com suporte ao Vision Framework (disponível a partir do iOS 17.0)
        }
    }
}
*/
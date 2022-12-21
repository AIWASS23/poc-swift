import SwiftUI

struct ScrollingView: View {
    var body: some View {
        ZStack {
            Image("Sua imagem de fundo")
                .resizable() // A imagem de fundo é exibida usando a visualização Image() e é configurada para se ajustar à tela usando o método resizable()
                .aspectRatio(contentMode: .fill) // O método aspectRatio() é usado para garantir que a imagem se ajuste corretamente à tela, independentemente da proporção de tela.
                .edgesIgnoringSafeArea(.all) // O método edgesIgnoringSafeArea() é usado para garantir que a imagem preencha toda a área da tela, ignorando qualquer área de segurança.
            
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(1..<20) { num in
                            GeometryReader { geo in
                                VStack {
                                    Image("Sua imagem q será 'scrollada' ")
                                        .resizable()
                                        .cornerRadius(10)
                                }
                                .rotation3DEffect(.degrees(-geo.frame(in: .global).minX) / 8, axis: (x: 0, y: 1, z: 0))
                            }.frame(width: 300, height: 300, alignment: .center)
                        }
                    }
                }
            }
        }
    }
}

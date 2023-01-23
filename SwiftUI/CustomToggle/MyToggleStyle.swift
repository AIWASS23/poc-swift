//
//  MyToggleStyle.swift
//  CustomSwitch
//
//  Created by Pratik on 08/10/22.
//

import SwiftUI

struct MyToggleStyle: ToggleStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { bounds in
            Button(action: {
//                withAnimation(.easeInOut) {
                    configuration.isOn.toggle()
//                }
            }, label: {
                ZStack {
                    background(isOn: configuration.isOn)
                    
                    LinearGradient(colors: [Color(uiColor: .darkGray), Color(uiColor: .lightGray)], startPoint: .top, endPoint: .bottom)
                        .mask {

                            /*
                                .mask é uma modificadora de view em SwiftUI que aplica uma máscara para 
                                limitar a visualização de um view para uma área específica. A máscara é 
                                aplicada usando outro view, que define a forma e a área da máscara. 
                                A máscara é aplicada com base na cor transparente, ou seja, qualquer área 
                                do view com a cor transparente será "cortada" e não será exibida.

                                É possível usar vários tipos de view como máscara, como Circle, 
                                RoundedRectangle, Capsule, etc. Além disso, a máscara pode ser aplicada a 
                                qualquer tipo de view, não apenas imagens.
                            */

                            Capsule()
                                .stroke(lineWidth: 6)
                        }
                        .shadow(color: .black.opacity(0.8), radius: 6, x: 0, y: 7)
                    
                    HStack {
                        if !configuration.isOn {
                            Spacer(minLength: 0)
                        }
                        thumb()
                            .frame(width: bounds.size.height, height: bounds.size.height, alignment: .center)
                            .padding(.vertical, 13)
                        if configuration.isOn {
                            Spacer(minLength: 0)
                        }
                    }
                    .padding(.horizontal, 13)
                }
                .clipShape(Capsule())
            })
            .buttonStyle(.plain)
        }
    }
    
    @ViewBuilder private func thumb() -> some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.08))
                .scaleEffect(2.8)
            
            Circle()
                .fill(Color.white.opacity(0.08))
                .scaleEffect(2.2)
            
            Circle()
                .fill(Color.white.opacity(0.08))
                .scaleEffect(1.6)
            
            Circle()
                .fill(Color(uiColor: .yellow))
                .overlay {
                    ZStack {
                        LinearGradient(colors: [Color(uiColor: .black), Color(uiColor: .white)], startPoint: .bottom, endPoint: .top)
                            .mask {
                                Circle()
                                    .stroke(lineWidth: 3)
                        }
                    }
                }
                .shadow(color: .black.opacity(0.6), radius: 20, x: 0, y: 10)

                /*
                    o método .shadow é usado para adicionar sombra a um elemento de interface. Ele é 
                    adicionado como um modificador a um elemento, geralmente um elemento de visualização 
                    como um Text, Image ou Shape. O método .shadow pode ser usado para especificar a cor, 
                    o tamanho, a opacidade e a posição da sombra. Aqui está um exemplo de como usar o 
                    método .shadow para adicionar uma sombra verde com opacidade de 0,5 a um Text:

                    Text("Hello World")
                    .shadow(color: .green, radius: 5, x: 0, y: 0)

                    Além disso, você pode adicionar sombras aos views de forma mais elaborada com o 
                    shadow() modificador, você pode especificar a cor, raio, deslocamento, e até mesmo dar 
                    sombras em outras direções diferentes, como o 
                    shadow(color: Color, radius: CGFloat, x: CGFloat, y: CGFloat, spread: CGFloat)
                */
        }
    }
    
    @ViewBuilder private func background(isOn: Bool) -> some View {
        ZStack {
            Color(uiColor: .systemBlue)
            
            HStack {
                if isOn {
                    Spacer(minLength: 0)
                    Image("cloud")
                        .resizable()
                        .scaledToFit()
                        .padding(.trailing, 20)
                        .transition(.opacity)
                } else {
                    StarsGenerator()
//                        .transition(.opacity)
                }
            }
        }
    }
    
    private struct StarsGenerator: View {
        static let starDefaultSize: CGFloat = 10
        static let defaultXPsotion: CGFloat = 50
        static let defaultYPsotion: CGFloat = 30
        
        @State private var stars: [StarModel] = []
        var body: some View {
            GeometryReader { bounds in
                ZStack {
                    ForEach(stars) { s in
                        Star(corners: 4, smoothness: 0.45)
                            .frame(width: s.size.width, height: s.size.height, alignment: .center)
                            .transition(.opacity)
                            .offset(x: s.offset.x, y: s.offset.y)
                    }
                }
                .frame(width: bounds.size.width, height: bounds.size.height, alignment: .center)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1)) {
                        for _ in 0...12 {
                            let size = CGFloat.random(in: 5...15)
                            stars.append(StarModel(offset: CGPoint(x: CGFloat.random(in: -bounds.size.width/2...bounds.size.width/2), y: CGFloat.random(in: -bounds.size.height/2...bounds.size.height/2)),
                                                   size: CGSize(width: size, height: size)))
                        }
                    }
                }
                .onReceive(Timer.publish(every: 1, on: .current, in: .default).autoconnect()) { _ in
                    withAnimation(.easeInOut(duration: 1)) {
                        stars.removeFirst()
                        let size = CGFloat.random(in: 5...15)
                        stars.append(StarModel(offset: CGPoint(x: CGFloat.random(in: -bounds.size.width/2...bounds.size.width/2), y: CGFloat.random(in: -bounds.size.height/2...bounds.size.height/2)),
                                               size: CGSize(width: size, height: size)))
                    }
                }
            }
        }
        
        private struct StarModel: Identifiable {
            var id = UUID()
            var offset: CGPoint
            var size: CGSize
        }
    }
}

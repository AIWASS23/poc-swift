import SwiftUI

struct SequenceAnimationHome: View {
    // MARK: Animation Properties
    @State var startAnimation: Bool = false
    @State var animationContent: Bool = false
    @State var animateText: [Bool] = [false, false]
    @State var backgroundWidth: CGFloat? = 60
    var body: some View {
        VStack(spacing: 15) {
            HeaderView()
            
            CardView()
                .padding(.top, 10)
                .zIndex(1)
            
            DetailCardView()
                .zIndex(0)
            
            CardView(cardColor: .orange, spent: "7821.25", cardNumber: "3653", cardIndex: 1)
                .padding(.top, 10)
            
        }
        .padding(15)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background {
            Color.black
                .frame(width: backgroundWidth)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .ignoresSafeArea()
            
        }
        .overlay(alignment: .trailing) {
            HStack(spacing: 10) {
                Text("My Cards")
                Image(systemName: "chevron.right")
            }
            .font(.system(size: 19))
            .fontWeight(.semibold)
            .foregroundStyle(Color.white)
            .contentShape(Rectangle())
            .onTapGesture {
                animatePage()
            }
            .rotationEffect(.init(degrees: -90))
            .offset(x: startAnimation ? 120 : 22)
            .opacity(startAnimation ? 0 : 1)
        }
        .background {
            Color.white
                .ignoresSafeArea()
        }
    }
    
    // MARK: Animation Wallet Page
    func animatePage() {
        withAnimation(.easeInOut(duration: 0.4)) {
            backgroundWidth = 40
        }
        
        withAnimation(.interactiveSpring(response: 1.1, dampingFraction: 0.75, blendDuration: 0).delay(0.3)) {
            backgroundWidth = nil
            startAnimation = true
        }
        
        // MARK: Enabling Rolling Counter
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.15) {
            animateText[0] = true
            animateText[1] = true
        }
    }
    
    // MARK: Detail Card View
    @ViewBuilder
    func DetailCardView() -> some View {
        VStack(alignment: .leading, spacing: 12, content: {
            Text(Date().formatted(date: .abbreviated, time: .omitted))
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
            
            Text("$695.50")
                .font(.title.bold())
                .foregroundStyle(.white)
                .offset(x: startAnimation ? 0 : 100)
                .opacity(startAnimation ? 1 : 0)
                .animation(.easeInOut(duration: 0.6).speed(0.7).delay(1.5), value: startAnimation)
            
            HStack {
                Button(action: {
                    
                }, label: {
                    Text("Manage")
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 25)
                        .background {
                            Capsule()
                                .stroke(.white, lineWidth: 1)
                            
                        }
                })
                
                Button(action: {
                    
                }, label: {
                    Text("Pay Now")
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 25)
                        .background {
                            Capsule()
                                .fill(.white)
                            
                        }
                })
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 12)
            .offset(y: startAnimation ? 0 : 100)
            .animation(.easeInOut(duration: 0.8).delay(1.8), value: startAnimation)
            
        })
        .overlay(alignment: .topTrailing) {
            Button(action: {
                
            }, label: {
                Text("Due")
                    .fontWeight(.semibold)
                    .foregroundStyle(.orange)
                    .underline(true, color: Color.orange)
            })
            .padding(15)
            .offset(x: startAnimation ? 0 : -100)
            .opacity(startAnimation ? 1 : 0)
            .animation(.easeInOut(duration: 0.8).speed(0.8).delay(1.7), value: startAnimation)
        }
        .padding(15)
        .background(Color(hex: "232121"))
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        .padding(.vertical, 10)
        
        // MARK: Animating Detail Card
        .rotation3DEffect(
            .init(degrees: startAnimation ? 0 : 30),
            axis: (x: 1, y: 0, z: 0),
            anchor: .center
        )
        .offset(y: startAnimation ? 0: -200)
        .opacity(startAnimation ? 1 : 0)
        .animation(.interactiveSpring(response: 1, dampingFraction: 0.9, blendDuration: 1).delay(1.2), value: startAnimation)
    }
    
    // MARK: Card View
    // Both cards animating at the same time, with the help of index, we can slow down the sub sequent cards animating timing
    func CardView(cardColor: Color = .white, spent: String = "5421.80", cardNumber: String = "1063", cardIndex: CFloat = 0) -> some View {
        let extraDelay: Double = Double(cardIndex / 3.5)
        // Simply add this delay to all the existing delay animation
        
        return VStack(alignment: .leading, spacing: 15) {
            Image("visaIcon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 45, height: 45)
                .offset(x: startAnimation ? 0 : 15, y: startAnimation ? 0 : 15)
                .opacity(startAnimation ? 1 : 0)
                .animation(.easeInOut(duration: 1).delay(1), value: startAnimation)
            
            HStack(spacing: 4) {
                Text("$")
                    .font(.title.bold())
                
                // MARK: Rolling Text
                let separatedString: [String] = spent.components(separatedBy: ".")
                if separatedString.indices.contains(0), animateText[0] {
                    RollingText(font: .title, weight: .bold, value: .constant(NSString(string: separatedString[0]).integerValue), animationDuration: 1.5)
                        .transition(.opacity)
                }
                
                Text(".")
                    .font(.title.bold())
                    .padding(.horizontal, -4)
                if separatedString.indices.contains(1), animateText[1] {
                    RollingText(font: .title, weight: .bold, value: .constant(NSString(string: separatedString[1]).integerValue), animationDuration: 1.5)
                        .transition(.opacity)
                }
            }
            .opacity(startAnimation ? 1 : 0)
            .animation(.easeInOut(duration: 1).delay(1.2 + extraDelay), value: startAnimation)
            .frame(maxWidth: .infinity, alignment: .leading)
            .overlay(alignment: .trailing) {
                CVVView()
                    .opacity(startAnimation ? 1 : 0)
                    .offset(x: startAnimation ? 0 : 70)
                    .animation(.interactiveSpring(response: 1, dampingFraction: 1, blendDuration: 1).delay(1.6), value: startAnimation)
            }
            
            Text("Balance")
                .fontWeight(.semibold)
                .foregroundStyle(.black)
                .opacity(startAnimation ? 1 : 0)
                .offset(y: startAnimation ? 0 : 70)
                .animation(.interactiveSpring(response: 1, dampingFraction: 1, blendDuration: 1).delay(1.5 + extraDelay), value: startAnimation)
            
            HStack {
                Text("****  ****  ****")
                    .font(.title)
                    .fontWeight(.semibold)
                    .kerning(3)
                
                Text("  " + cardNumber)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .offset(y: -6)
            }
            .opacity(startAnimation ? 1 : 0)
            .offset(y: startAnimation ? 0 : 70)
            .animation(.interactiveSpring(response: 1, dampingFraction: 1, blendDuration: 1).delay(1.6 + extraDelay), value: startAnimation)
            
        }
        .padding(15)
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity)
        .background(cardColor)
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        // MARK: Animating Card
        .rotation3DEffect(
            .init(degrees: startAnimation ? 0 : -70),
            axis: (x: 1, y: 0, z: 0),
            anchor: .center
        )
        .scaleEffect(startAnimation ? 1 : 0.001, anchor: .bottom)
        .animation(.interactiveSpring(response: 1, dampingFraction: 0.7, blendDuration: 1).delay(0.9 + extraDelay), value: startAnimation)
    }
    
    // MARK: CVV View
    @ViewBuilder
    func CVVView() -> some View {
        HStack(spacing: 5) {
            ForEach(0..<3, id: \.self) { _ in
                Circle()
                    .frame(width: 8, height: 8)
            }
        }
        .padding(.trailing, 8)
    }
    
    // MARK: Header View
    @ViewBuilder
    func HeaderView() -> some View {
        HStack {
            Text("My Cards")
                .font(.title.bold())
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .opacity(startAnimation ? 1 : 0)
                .offset(x: startAnimation ? 0 : 100)
                .animation(.interactiveSpring(response: 1, dampingFraction: 1, blendDuration: 1).delay(0.9), value: startAnimation)
            
            Button {
                
            } label: {
                Image(systemName: "plus")
                    .font(.title2.bold())
                    .foregroundStyle(Color.black)
                    .padding(10)
                    .background {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(.white)
                    }
            }
            .scaleEffect(startAnimation ? 1 : 0.001)
            .animation(.interactiveSpring(response: 1, dampingFraction: 0.6, blendDuration: 0.7).delay(0.7), value: startAnimation)
        }
    }
}

#Preview {
    SequenceAnimationHome()
}

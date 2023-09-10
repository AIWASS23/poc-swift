import SwiftUI

struct SplitApp: View {
    var body: some View {
        BillSplitHome()
    }
}

struct BillSplitHome: View {
    let bgColor = Color(hex: "49426e")
    let cardColor = Color(hex: "f1c290")
    
    // Total amount
    @State var bill: CGFloat = 750
    
    @State var payers: [Payer] = [
        .init(image: "animoji2", name: "Andy", bgColor: Color(hex: "b399e9")),
        .init(image: "animoji1", name: "Blue", bgColor: Color(hex: "98c3ef")),
        .init(image: "animoji3", name: "Dylan", bgColor: Color(hex: "e9a693")),
    ]
    
    // Temp offset
    @State var pay: Bool = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                HStack {
                    Button(action: {}, label: {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.gray)
                            .padding()
                            .background(Color.black.opacity(0.25))
                            .cornerRadius(15)
                    })
                    
                    Spacer()
                }
                .padding()
                
                // Bill card view
                VStack(spacing: 15) {
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Text("Receipt")
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(bgColor)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    })
                    
                    // Dotted lines ...
                    Line()
                        .stroke(.black, style: .init(lineWidth: 1, lineCap: .butt, lineJoin: .miter, dash: [10]))
                        .frame(height: 1)
                        .padding(.horizontal)
                        .padding(.top, 10)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 12, content: {
                            Text("Title")
                                .font(.caption)
                            
                            Text("Team Diner")
                                .font(.title2)
                                .fontWeight(.heavy)
                        })
                        .foregroundStyle(bgColor)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 10)
                        
                        VStack(alignment: .leading, spacing: 12, content: {
                            Text("Total Bill")
                                .font(.caption)
                            
                            Text("\(String(format: "%.3f", bill)) VND")
                                .font(.title2)
                                .fontWeight(.heavy)
                        })
                        .foregroundStyle(bgColor)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 10)
                    }
                    
                    // Animoji views
                    VStack {
                        HStack(spacing: -20) {
                            ForEach(payers, id: \.id) { payer in
                                Image(payer.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60, height: 60)
                                    .padding(10)
                                    .background(payer.bgColor)
                                    .clipShape(Circle())
                            }
                        }
                        
                        Text("Splitting")
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(bgColor)
                    .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                    
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(cardColor.clipShape(BillShape())
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                )
                .padding(.horizontal)
                
                ForEach(payers.indices) { index in
                    PriceView(payer: $payers[index], totalAmount: bill)
                }
                
                Spacer(minLength: 25)
                
                // Pay button
                HStack {
                    HStack(spacing: 0) {
                        ForEach(1...6, id: \.self) { index in
                            Image(systemName: "chevron.right")
                                .font(.system(size: 20, weight: .heavy))
                                .foregroundStyle(.white.opacity(Double(index) * 0.06))
                        }
                    }
                    .padding(.leading, 45)
                    
                    Spacer()
                    
                    Button(action: {
                        pay.toggle()
                    }, label: {
                        Text("Confirm Split")
                            .fontWeight(.bold)
                            .foregroundStyle(cardColor)
                            .padding(.horizontal, 25)
                            .padding(.vertical)
                            .background(bgColor)
                            .clipShape(Capsule())
                    })
                }
                .padding()
                .background(.black.opacity(0.25))
                .clipShape(Capsule())
                .padding(.horizontal)
            }
        }
        .background(bgColor.ignoresSafeArea(.all, edges: .all))
        // Alert view
        .alert(isPresented: $pay) {
            Alert(title: Text("Alert"), message: Text("Confirm to Split Pay"), primaryButton: .default(Text("Pay"), action: {
                    
            }), secondaryButton: .destructive(Text("Cancel"), action: {
                
            }))
        }
    }
}

// MARK: Price Split View
struct PriceView: View {
    @Binding var payer: Payer
    var totalAmount: CGFloat
    var body: some View {
        VStack(spacing: 15, content: {
            // Custom Slider
            HStack {
                Image(payer.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .padding(5)
                    .background(payer.bgColor)
                    .clipShape(Circle())
                
                Text(payer.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                Spacer()
                
                Text(getPrice())
                    .fontWeight(.heavy)
                    .foregroundStyle(.white)
            }
            
            ZStack(alignment: .init(horizontal: .leading, vertical: .center), content: {
                Capsule()
                    .fill(.black.opacity(0.25))
                    .frame(height: 30)
                Capsule()
                    .fill(payer.bgColor)
                    .frame(width: payer.offset + 20, height: 30)
                
                // Dots
                HStack(spacing: (UIScreen.main.bounds.width - 100) / 12) {
                    ForEach(0..<12, id: \.self) { index in
                        Circle()
                            .fill(.white)
                            .frame(width: index % 4 == 0 ? 7 : 4, height: index % 4 == 0 ? 7 : 4)
                        
                    }
                }
                .padding(.leading)
                
                Circle()
                    .foregroundStyle(Color(hex: "f1c290"))
                    .frame(width: 35, height: 35)
                    .background {
                        Circle()
                            .stroke(.white, lineWidth: 5)
                    }
                    .offset(x: payer.offset)
                    .gesture(DragGesture().onChanged({ value in
                        // Padding Horizontal
                        // Padding horizontal = 30
                        // Circle radius = 20
                        if value.location.x > 15 && value.location.x < UIScreen.main.bounds.width - 50 {
                            payer.offset = value.location.x - 20
                        }
                    }))
            })
            
        })
        .padding()
    }
    
    func getPrice() -> String {
        let percent = payer.offset / (UIScreen.main.bounds.width - 70)
        let amount = percent * (totalAmount / 3)
        return "\(String(format: "%.3f", amount)) VND"
    }
}

// MARK: Line shape ...
fileprivate struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: .init(x: 0, y: 0))
            path.addLine(to: .init(x: rect.width, y: 0))
        }
    }
}

// MARK: Custom Bill Card Shape
struct BillShape: Shape {
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: .zero)
            path.addLine(to: .init(x: 0, y: rect.height))
            path.addLine(to: .init(x: rect.width, y: rect.height))
            path.addLine(to: .init(x: rect.width, y: 0))
         
            path.move(to: .init(x: 0, y: 80))
            path.addArc(center: .init(x: 0, y: 80), radius: 20, startAngle: .init(degrees: -90), endAngle: .init(degrees: 90), clockwise: false)
            
            path.move(to: .init(x: rect.width, y: 80))
            path.addArc(center: .init(x: rect.width, y: 80), radius: 20, startAngle: .init(degrees: 90), endAngle: .init(degrees: -90), clockwise: false)
        }
    }
}


struct Payer: Identifiable {
    var id = UUID().uuidString
    var image: String
    var name: String
    var bgColor: Color
    
    // Offset for custom progress view
    var offset: CGFloat = 0
}

#Preview {
    BillSplitApp()
}

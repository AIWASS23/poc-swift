import SwiftUI

struct SplashView: View {
    
    @State var isActive: Bool = false
    
    var body: some View {
        VStack {
                    // 2.
                    if self.isActive {
                        // 3.
                        tabview()
                    } else {
                        // 4.
                        ZStack{
                            Rectangle()
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.black)
                                .ignoresSafeArea()
                            
                            VStack{
                                
                                Spacer()
                                
                                Image("logo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 400, height: 400, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                
                                Spacer()
                                
                                
                                
                                Text("Lembrete")
                                    .bold()
                                    .font(.title)
                                    .foregroundColor(.white)
                                Text(versao)
                                    .foregroundColor(.white)
                                
                            }
                        }
                        
                    }
        }
       
                // 5.
                .onAppear {
                    // 6.
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        // 7.
                        withAnimation {
                            self.isActive = true
                        }
                    }
                }

    }
}

#Preview {
    SplashView()
}

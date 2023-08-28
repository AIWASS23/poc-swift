import SwiftUI

struct Login: View {
    
    @State var email: String = ""
    @State var senha: String = ""
    
    
    var body: some View {
        VStack{
                Text("Olá,")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title)
                    .bold()
                
                Text("Faça seu login.")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .bold()
                    .padding(.bottom, 30)
            
            
            
            TextField("E-mail", text: $email)
                .frame(maxWidth: .infinity)
                .textFieldStyle(.roundedBorder)
            
            SecureField("Senha", text: $senha)
                .frame(maxWidth: .infinity)
                .textFieldStyle(.roundedBorder)
        }
        
        .padding(.horizontal)
    }
}

#Preview {
    Login()
}
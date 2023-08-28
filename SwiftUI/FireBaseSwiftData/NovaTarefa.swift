import SwiftUI
import SwiftData

struct NovaTarefa: View {
    @Environment(\.modelContext) private var modelContext
    
    @State var nomeTarefa: String = ""
    @State var descricaoTarefa: String = ""
    @State var data: Date = Date.now
    @State var prioridade: Int = 1
    @State var projeto: String = "Inbox"
    @State var statusTarefa: Bool = false
    
    
   
    var body: some View {
        NavigationView{
            ScrollView{
                VStack{
                    Text("Nome da Tarefa:")
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                        .bold()
                    
                    TextField("nome da tarefa...", text: $nomeTarefa)
                        .textFieldStyle(.roundedBorder)
                    
                    Text("Descrição da Tarefa:")
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                        .padding(.top)
                        .bold()
                    
                    TextField("nome da tarefa...", text: $descricaoTarefa)
                        .textFieldStyle(.roundedBorder)
                    
                    HStack{
                        Spacer()
                        Button(action: {
                            print("Data")
                            self.data = Date.now
                        }, label: {
                            Image(systemName: "calendar")
                                .resizable()
                                .frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        })
                        
                        Spacer()
                        Menu{
                            Button(action: {prioridade = 1}, label: {imagemTexto(imagem: "exclamationmark", texto: "Prioridade 1")})
                            Button(action: {prioridade = 2}, label: {imagemTexto(imagem: "exclamationmark.2", texto: "Prioridade 2")})
                            Button(action: {prioridade = 3}, label: {imagemTexto(imagem: "exclamationmark.3", texto: "Prioridade 3")})
                            
                        } label:{
                            Image(systemName: "exclamationmark.triangle")
                                .resizable()
                                .frame(width: 35, height: 35, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        }
                        
                        Spacer()
                            Menu{
                                Button(action: {projeto = "Inbox"}, label: {imagemTexto(imagem: "archivebox", texto: "Inbox")})
                                Button(action: {projeto = "Vida Pessoal"}, label: {imagemTexto(imagem: "person", texto: "Vida Pessoal")})
                                Button(action: {projeto = "Vida Profissional"}, label: {imagemTexto(imagem: "brain.head.profile", texto: "Vida Profissional")})
                                Button(action: {projeto = "Descanso"}, label: {imagemTexto(imagem: "beach.umbrella", texto: "Descanso")})
                                Button(action: {projeto = "Família"}, label: {imagemTexto(imagem: "figure.2.and.child.holdinghands", texto: "Família")})
                            } label:{
                                Image(systemName: "square.and.pencil")
                                    .resizable()
                                    .frame(width: 35, height: 35, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            }
                        Spacer()
                        
                    }
                    .padding()
                    
                    Button(action: {
                        print("salvar")
                        let novaTarefa = Tarefa(nome: nomeTarefa, descricao: descricaoTarefa, data: data, prioridade: prioridade, projeto: projeto, status: false)
                        modelContext.insert(object: novaTarefa)
                        
                    }, label: {
                        botaoSalvar()
                            .padding(.vertical, 30)
                    })

                    
                }
                .padding(.horizontal)
            }
            
            .navigationTitle("Nova Tarefa")
        }
    }
}

#Preview {
    NovaTarefa()
        .modelContainer(for: Tarefa.self, inMemory: true)
}




//MARK: - Estruturas de modificação
struct botaoSalvar: View{
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 5)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 20, idealHeight: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            Text("Salvar Tarefa")
                .foregroundColor(.white)
                .bold()
        }
    }
}

struct imagemTexto: View{
    
    @State var imagem: String = ""
    @State var texto: String = ""
    
    var body: some View{
        HStack{
            Image(systemName: imagem)
            Text(texto)
        }
    }
}

import SwiftUI
import SwiftData

struct ListaDeTarefas: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var tarefa: [Tarefa]
    
    @State var showSheetView: Bool = false
    
    @State var loginStatus: Bool = true
    @AppStorage("notLoginYet") var isParameterTrue: Bool = true
    
    var body: some View {
        NavigationView {
            List {
                ForEach(tarefa) { tarefa in
                    apresentacaoTarefa(nome: tarefa.nome, descricao: tarefa.descricao, prioridade: tarefa.prioridade, projeto: tarefa.projeto, data: tarefa.data, status: tarefa.status)
                        .swipeActions{
                            Button("Deletar", role: .destructive){
                                modelContext.delete(tarefa)
                            }
                        }
                }
                
                
            }
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showSheetView.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }

                }
            }
            .onAppear{if isParameterTrue{loginStatus = true}}
            .sheet(isPresented: $loginStatus, content: {Login()})
            .sheet(isPresented: $showSheetView, content: {NovaTarefa()})
            .navigationTitle("Lista de Tarefas")
        }
    }
}

#Preview {
    ListaDeTarefas()
        .modelContainer(for: Tarefa.self, inMemory: true)
}


//MARK: - Estruturas auxiliares

struct apresentacaoTarefa: View{
    
    @State var nome: String = ""
    @State var descricao: String = ""
    @State var prioridade: Int = 1
    @State var projeto: String = ""
    @State var data: Date = Date.distantFuture
    @State var status: Bool = false
    
    let larguraExclamacao: CGFloat = 5
    
    var body: some View{
        VStack{
            HStack{
                
                Text(nome)
                    .bold()
                
                Spacer()
                
                if prioridade == 1{
                    Image(systemName: "exclamationmark")
                        .frame(width: larguraExclamacao)
                }else if prioridade == 2{
                    Image(systemName: "exclamationmark.2")
                        .frame(width: larguraExclamacao)
                }else{
                    Image(systemName: "exclamationmark.3")
                        .frame(width: larguraExclamacao)
                }
            }
            Text(descricao)
                .font(.subheadline)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: .leading)
            
            HStack{
                
                Text("\(data, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    .font(.footnote)
                
                Spacer()
                
                if projeto == "Família"{
                    imagemTexto(imagem: "figure.2.and.child.holdinghands", texto: "Família")
                }else if projeto == "Vida Pessoal"{
                    imagemTexto(imagem: "person", texto: "Vida Pessoal")
                }else if projeto == "Vida Profissional"{
                    imagemTexto(imagem: "brain.head.profile", texto: "Vida Profissional")
                }else if projeto == "Descanso"{
                    imagemTexto(imagem: "beach.umbrella", texto: "Descanso")
                }else{
                    imagemTexto(imagem: "archivebox", texto: "Inbox")
                }
            }
        }
    }
}
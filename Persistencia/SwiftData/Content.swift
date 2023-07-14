import SwiftUI
import SwiftData

struct ContentView: View {

    @Environment(\.modelContext) private var modelContext
    /*
        Esta linha de código obtém o contexto do modelo de dados da instância atual da aplicação. O contexto 
        do modelo de dados é usado para acessar e modificar os dados persistidos.
    */
    
    @Query private var allPersons: [Person]
    /*
        Esta linha de código define uma consulta que retorna uma lista de todas as pessoas no modelo de dados.
    */
    
    @Query(filter: #Predicate { $0.personIsHired == true }) private var hiredPersons: [Person]
    /*
        Esta linha de código define uma consulta que retorna uma lista de todas as pessoas que estão 
        contratadas. A consulta usa o operador #Predicate para filtrar as pessoas com base no estado de 
        emprego delas.
    */
    
    @Query(filter: #Predicate { $0.personIsHired == false }) private var firedPersons: [Person]
    /*
        Esta linha de código define uma consulta que retorna uma lista de todas as pessoas que foram 
        demitidas. A consulta usa o operador #Predicate para filtrar as pessoas com base no estado de 
        emprego delas.
    */

    // https://developer.apple.com/documentation/swiftdata/query
    // https://developer.apple.com/documentation/coredata/adopting_swiftdata_for_a_core_data_app


    
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Hired")) {
                    ForEach(hiredPersons) { person in
                        
                        HStack {
                            Text("Name: \(person.personName)")
                            Text("Age: \(person.personAge)")
                            
                            Button {
                                withAnimation {
                                    person.personIsHired.toggle()
                                 
                                }
                                
                            } label: {
                                Image(systemName: person.personIsHired ? "heart.fill" : "heart")
                                    .tint(.red)
                            }
                        }
                        .swipeActions{
                            Button {
                                modelContext.delete(person)
                                
                            } label: {
                                Image(systemName: "trash")
                            }
                            
                        }
                        
                    }
                    
                }
                
                Section(header: Text("Fired")) {
                    ForEach(firedPersons) { person in
                        
                        HStack {
                            Text("Name: \(person.personName)")
                            Text("Age: \(person.personAge)")
                            
                            Button {
                                withAnimation {
                                    person.personIsHired.toggle()
                                    
                                }
                                
                            } label: {
                                Image(systemName: person.personIsHired ? "heart.fill" : "heart")
                                    .tint(.gray)
                            }
                        }
                        .swipeActions{
                            Button {
                                modelContext.delete(person)
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                    }
                }

                /*
                    Esta seção do código cria uma lista de pessoas que são exibidas na interface do usuário. 
                    A lista é dividida em duas seções: "Hired" e "Fired". Cada seção exibe uma lista de 
                    pessoas com o estado de emprego correspondente.
                */
            }
            
            .toolbar {
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }
        
    }
    
    private func addItem() {
        withAnimation {
            let newPerson = Person(
                personName: " \(UUID().uuidString.prefix(10))", 
                personAge: Int.random(in: 18...70), 
                timeStamp: Date()
            )
            modelContext.insert(object: newPerson)

            /*
                Esta função adiciona uma nova pessoa ao modelo de dados. A função gera um novo UUID para o 
                nome da pessoa, gera uma idade aleatória para a pessoa e insere a pessoa no modelo de dados.
            */
            
        }
    }
    
}

#Preview {
    ContentView()
        .modelContainer(for: Person.self, inMemory: true)
}
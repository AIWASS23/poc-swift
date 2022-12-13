
import SwiftUI

struct ContentView: View {

    /*  @State nos permite contornar a limitação das structs:
        sabemos que não podemos alterar suas propriedades porque as structs são fixas,
        mas @State permite que esse valor seja armazenado separadamente pelo SwiftUI
        em um local que pode ser modificado.
        A Apple recomenda adicionar PRIVATE ao controle de acesso a essas propriedades
    */
    @State private var checkAmount = 0.0 
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20

    /*
        O @FocusState é exatamente como uma @State, 
        exceto que é especificamente projetado para lidar com o foco de entrada
        em nossa interface do usuário.
    */

    @FocusState private var amountIsFocused: Bool
    
    let tipPercentages = [10, 15, 20, 25, 0]
    
    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople + 2)
        let tipSelection = Double(tipPercentage)
        
        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = checkAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        
        return amountPerPerson
    }
    
    var body: some View {
        NavigationView { // Barra de navegação
            Form { 
                Section {
                    /*
                        LOCALE é uma estrutura massiva incorporada ao iOS que é responsável
                        por armazenar todas as configurações de região do usuário:
                        qual calendário ele usa, como separa milhares de dígitos em números,
                        se usa o sistema métrico e muito mais. 

                        FORMAT é uma exibição de texto do SwiftUI capaz
                        de mostrar datas, matrizes, medições e muito mais,
                        tudo por meio de seus parâmetros. 
                        No entanto, isso está disponível apenas no iOS 15, 
                        portanto, para suporte ao iOS 14 e 13, use o FORMATTER.
                    */
                    TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                        .keyboardType(.decimalPad)                                   
                        .focused($amountIsFocused)
                    
                    Picker("Number of people", selection: $numberOfPeople) {
                        /*
                            O SwiftUI nos fornece um tipo de visualização dedicado para essa finalidade,
                            chamado ForEach. Isso pode percorrer matrizes e intervalos,
                            criando quantas visualizações forem necessárias. 
                            Melhor ainda, ForEach não é atingido pelo limite de 10 visualizações
                            que nos afetaria se tivéssemos digitado as visualizações manualmente.
                        */
                        ForEach(2..<100) {
                            Text("\($0) people")
                        }
                    }
                }
                
                Section {
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(tipPercentages, id: \.self) {
                            Text($0, format: .percent)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("How much tip do you want to leave?")
                }
                
                Section {
                    Text(totalPerPerson, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                }
            }
            .navigationTitle("WeSplit")

            /*
                O TOOLBAR é um modificador nos permite especificar itens da barra de ferramentas 
                para uma exibição. Esses itens da barra de ferramentas podem aparecer 
                em vários locais da tela – na barra de navegação na parte superior, 
                em uma área especial da barra de ferramentas na parte inferior e assim por diante.
            */

            .toolbar {

                /*
                    O ToolbarItemGroup nos permite colocar um ou mais botões em um local específico, 
                    e é aqui que especificamos que queremos uma barra de ferramentas do teclado, 
                    uma barra de ferramentas anexada ao teclado, 
                    para que apareça e desapareça automaticamente com o teclado.
                */

                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

/* 
    Text("Your name is \(name)") Unidirecional somente LER
    Text("Your name is $name") Bidirecional Ler e Escreve
*/

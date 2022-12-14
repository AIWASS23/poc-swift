import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1

    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false

    static var defaultWakeTime: Date {
        var components = DateComponents() // DateComponents permite ler ou escrever partes específicas de uma data.
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now // Se o Components retornar nil devolve a data atual.
    }

    var body: some View {
        NavigationView {
            Form {
                VStack(alignment: .leading, spacing: 0) {
                    Text("When do you want to wake up?")
                        .font(.headline)

                    /*
                        DatePicker é um seletor que pode ser vinculado a uma propriedade Date.
                        Para usá-lo, temos q vincula-lo a um @State
                    */

                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)

                    /*
                        displayedComponents decide que tipo de opções o usuário deve ver
                        .date (Calendario)
                        .hourAndMinute (horas e minutos)
                    */

                        .labelsHidden() // Apaga o rótulo gerado pelo VOICE OVER
                }

                VStack(alignment: .leading, spacing: 0) {
                    Text("Desired amount of sleep")
                        .font(.headline)

                    /*
                        O Stepper permite que o usuário insira números trata-se de um botão simples 
                        - e + que pode ser tocado para selecionar um número preciso.
                        IN: limitar os valores de aceitação
                        STEP: O quanto mover de valor a cada click no + ou -
                    */

                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }

                VStack(alignment: .leading, spacing: 0) {
                    Text("Daily coffee intake")
                        .font(.headline)

                    Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", value: $coffeeAmount, in: 1...20)
                }
            }
            .navigationTitle("BetterRest")
            .toolbar {
                Button("Calculate", action: calculateBedtime)
            }
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
    }

    func calculateBedtime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config) // https://www.youtube.com/watch?v=a905KIBw1hs tutorial pra criar um ML

            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60

            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))

            let sleepTime = wakeUp - prediction.actualSleep
            alertTitle = "Your ideal bedtime is…"
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
        }

        showingAlert = true
    }
}

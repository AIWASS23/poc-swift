import Foundation
import SwiftUI
import Charts

/*
    Esse script define uma estrutura chamada SimpleBabyChart, que é uma visualização gráfica usando a 
    biblioteca Chart. Ele usa dados do tipo [BabyNamesDataPoint] e exibe-os como uma área de marcação, com 
    diferentes cores para diferentes nomes. Ele também tem marcas de regra para mostrar a data de maior 
    popularidade de cada nome, com uma anotação que mostra o nome. Além disso, ele usa um estilo de 
    gradiente para destacar a escala de dados e tem uma tarefa que atualiza as marcas de regra quando os 
    dados mudam.
*/

struct SimpleBabyChart: View {
    let data: [BabyNamesDataPoint]

    @State var datesOfMaximumProportion: [
        (date: Date, name: String, yStart: Float, yEnd: Float)
    ] = []

    var body: some View {
        Chart {
            ForEach(data) { point in
                AreaMark(
                    x: .value("Date", point.year),
                    y: .value("Count", point.count),
                    stacking: .center
                ).foregroundStyle(by: .value("Name", point.name))
            }
            ForEach(
                datesOfMaximumProportion,
                id: \.name
            ) { point in
                RuleMark(
                    x: .value(
                        "Date of highest popularity for \(point.name)",
                        point.date
                    )
                )
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient (
                            colors: [
                                .indigo.opacity(0.05),
                                .purple.opacity(0.5)
                            ]
                        ),
                        startPoint: .top,
                        endPoint: .bottom
                    ).blendMode(.darken)
                )
            }

            ForEach(datesOfMaximumProportion, id: \.name) { point in
                RuleMark(
                    x: .value("Date of highest popularity for \(point.name)", point.date),
                    yStart: .value("", point.yStart),
                    yEnd: .value("", point.yEnd)
                )
                .lineStyle(StrokeStyle(lineWidth: 0))

                .annotation(
                    position: .overlay,
                    alignment: .center,
                    spacing: 4
                ){ context in
                    Text(point.name)
                        .font(.subheadline)
                        .padding(2)
                        .fixedSize()
                        .background(
                            RoundedRectangle(cornerRadius: 2)
                                .fill(.ultraThinMaterial)
                        )
                        .rotationEffect(
                            .degrees(-90),
                            anchor: .center
                        )
                        .fixedSize()
                        .foregroundColor(.secondary)
                }
            }
        }
        .chartForegroundStyleScale(
            range: Gradient (
                colors: [
                    .purple,
                    .blue.opacity(0.3)
                ]
            )
        )
        // Executa esta tarefa novamente se alterarmos o número de pontos de dados
        .task(id: data.count) {

            self.datesOfMaximumProportion = []

            var namesToMaxProportion: [String: (proportion: Float, date: Date)] = [:]
            for point in self.data {
                if namesToMaxProportion[point.name]?.proportion ?? 0 < point.proportion {
                    namesToMaxProportion[point.name] = (point.proportion, point.year)
                }
            }

            self.datesOfMaximumProportion = namesToMaxProportion.map { (key: String, value) in
                let name = key
                var countOnDate = 0
                var countBeforeOnDate = 0
                var countAfterOnDate = 0

                // Percorre todos os dados
                for point in self.data {
                    // Considera pontos de dados para este ano
                    if point.year != value.date { continue }
                    if point.name == name {
                        countOnDate = point.count
                        continue
                    }

                    if countOnDate != 0 {
                        // Trata com seções que vêm após este nome
                        countAfterOnDate += point.count
                    } else {
                        // Trata com seções que vêm antes deste nome
                        countBeforeOnDate += point.count
                    }
                }

                let totalHeightOnDate = countOnDate + countAfterOnDate + countBeforeOnDate
                // A altura é centrada sobre o eixo
                let lowestValue = -1 * Float(totalHeightOnDate) / 2.0
                let yStart = lowestValue + Float(countBeforeOnDate)
                let yEnd = yStart  + Float(countOnDate)

                return (value.date, key, yStart, yEnd)
            }
        }
    }

    /*
        Este código cria um gráfico com marcas de área e marcas de regra, que são usadas para mostrar a data 
        de maior popularidade para cada nome. O gráfico é criado usando um loop ForEach para percorrer os 
        pontos de dados e criar AreaMarks para cada ponto. Um segundo loop ForEach é usado para criar 
        RuleMarks para as datas de proporção máxima. As RuleMarks são anotadas com Texto que exibe o nome 
        associado à data de maior popularidade. O chartForegroundStyleScale é definido como um gradiente 
        entre a opacidade roxa e azul 0,3 e há uma tarefa que é executada se o número de pontos de dados 
        for alterado. Essa tarefa percorre todos os pontos de dados, localiza a data de maior popularidade 
        para cada nome e a armazena em uma matriz chamada dateOfMaximumProportion.
    */
}

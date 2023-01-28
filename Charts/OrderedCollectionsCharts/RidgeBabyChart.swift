import Foundation
import SwiftUI
import Charts
import OrderedCollections

/*
    Esse código cria uma exibição RidgeBabyChart que usa a estrutura de dados OrderedDictionary para criar 
    um gráfico com vários elementos AreaMark e LineMark. O ambiente colorScheme é usado para determinar as 
    cores do gradiente, que é usado como estilo de primeiro plano do gráfico. O gráfico também possui um 
    eixo y oculto e uma legenda. A estrutura AreaChartForName cria um elemento ChartContent para cada ponto 
    de dados no dicionário groupedData, que contém objetos BabyNamesDataPoint. Cada elemento AreaMark e 
    LineMark recebe um valor para "Ano", "Proporção" e "Nome do bebê". O elemento RuleMark é usado para 
    adicionar uma anotação na parte superior do gráfico com o nome de cada nome de bebê no dicionário 
    groupedData.
*/

struct RidgeBabyChart: View {

    @Environment(\.colorScheme) var scheme

    let groupedData: OrderedDictionary<String, [BabyNamesDataPoint]>

    var body: some View {
        Chart {
            ForEach(
                Array(groupedData.enumerated()),
                id: \.offset
            ) { (offset, element) in
                let offsetFactor: CGFloat = CGFloat(groupedData.count - 1 - offset) * -35

                AreaChartForName(
                    name: element.key,
                    dataPoints: element.value
                )
                .offset(y: offsetFactor)
            }
        }
        .chartYScale(domain: 0 ... 0.2)
        .chartYAxis(.hidden)
        .chartForegroundStyleScale(
            range: gradient
        )
        .chartXScale(range: .plotDimension(startPadding: 60))
        .chartLegend(.hidden)
    }

    var gradient: Gradient {
        var colors: [Color] = [
            .blue,
            .teal
        ]

        if scheme == .light {
            colors.reverse()
        }

        return Gradient (colors: colors)
    }
}

struct AreaChartForName: ChartContent {
    let name: String
    let dataPoints: [BabyNamesDataPoint]

    var body: some ChartContent {
        ForEach(dataPoints) { point in
            AreaMark(
                x: .value("Year", point.year),
                y: .value("Proportion", point.proportion),
                stacking: .unstacked
            )
            .interpolationMethod(.cardinal)
            .foregroundStyle(by: .value("Baby Name", point.name))

            LineMark(
                x: .value("Year", point.year),
                y: .value("Proportion", point.proportion),
                series: .value("Baby Name", point.name)
            )
            .interpolationMethod(.cardinal)
            .accessibilityHidden(true).foregroundStyle(.thinMaterial)
        }

        RuleMark(y: .value("", 0))
        .foregroundStyle(by: .value("Baby Name", name))
        .annotation(position: .top, alignment: .leading, spacing: 2) {
            Text(name).font(.subheadline)
        }
        .accessibilityHidden (true)
    }
}

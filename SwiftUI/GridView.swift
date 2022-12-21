import SwiftUI

struct ContentView: View {
    var body: some View {
        Grid(alignment: .topLeading,
             horizontalSpacing: 5,
             verticalSpacing: 5) {
            GridRow {
                CustomRectangle(color: .yellow)
                CustomRectangle(color: .yellow)
                CustomRectangle(color: .yellow)
            }
            GridRow {
                Color.clear
                /*
                    O método gridCellUnsizedAxes() é uma extensão da visualização LazyVGrid que 
                    permite a você especificar quais eixos de células de grade não devem ter um tamanho fixo. 
                    Isso significa que as células da grade serão redimensionadas 
                    dinamicamente para se adequar ao tamanho da grade.

                    Se você usar .gridCellUnsizedAxes([.vertical]), 
                    as células da grade na direção vertical serão redimensionadas dinamicamente 
                    para se adequar ao tamanho da grade, 
                    enquanto as células na direção horizontal terão um tamanho fixo.

                    Se você usar .gridCellUnsizedAxes([.vertical, .horizontal]), 
                    ambos os eixos de células da grade serão redimensionados dinamicamente. 
                    Isso pode ser útil se você quiser criar uma grade que se adapte 
                    automaticamente ao tamanho da tela.

                    Para usar o gridCellUnsizedAxes(), você precisa incluí-lo 
                    como um modificador da visualização LazyVGrid ou Grid que deseja configurar.
                */
                    .gridCellUnsizedAxes([.vertical, .horizontal])
                CustomRectangle(color: .red)
                CustomRectangle(color: .red)
            }
            GridRow {
                Color.clear
                    .gridCellUnsizedAxes([.vertical, .horizontal])

                    /*
                        O gridCellColumns() é um método de extensão da visualização LazyVGrid ou Grid 
                        que permite especificar o número de colunas.

                        O método gridCellColumns espera um parâmetro de tipo Int, 
                        que é o número de colunas desejadas. 
                        Você também pode usar outros métodos de extensão da 
                        visualização LazyVGrid ou Grid, como gridCellRows() 
                        que serve para especificar o número de linhas na grade.
                    */

                    .gridCellColumns(2)
                CustomRectangle(color: .green)
            }
            GridRow {
                Rectangle()
                    .frame(width: 20, height: 20)
                    .gridColumnAlignment(.trailing)
                    //.gridCellAnchor(.center)
                CustomRectangle(color: .red)
            }
           
        }
        .padding()
    }
}

struct CustomRectangle: View {
    var color: Color
    var body: some View {
        Rectangle()
            .foregroundColor(color)
            .frame(width: 100, height: 100)
    }
}

import SwiftUI
import SwiftData

struct tabview: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        TabView {
            ListaDeTarefas()
                .tabItem {
                    Label(
                        title: { Text("tarefas") },
                        icon: { Image(systemName: "list.bullet") }
                    )
                }
            Charts()
                .tabItem {
                    Label(
                        title: { Text("Gráficos") },
                        icon: { Image(systemName: "chart.bar") }
                    )
                }
            
        }
    }
}

#Preview {
    tabview()
        .modelContainer(for: Tarefa.self, inMemory: true)
}

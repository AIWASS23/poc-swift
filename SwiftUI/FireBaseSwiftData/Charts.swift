
import SwiftUI

struct Charts: View {
    
    @State private var sheetView: Bool = false
    
    var body: some View {
        NavigationView{
            VStack{
                Image(systemName: "chart.bar.fill")
                    .resizable()
                    .foregroundColor(.blue)
                    .frame(width: 50, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                Text("Futura telas de gráficos")
                    .bold()
            }
        
        .toolbar{
            ToolbarItem(placement: .topBarTrailing) {
                Button(action:{
                    sheetView = true
                    print(sheetView)
                }, label: {
                    Image(systemName: "person.fill")
                })
            }
          }.sheet(isPresented: $sheetView, content: {
              Login()
          })
            
          .navigationTitle("Charts")
        }
    }
    
}

#Preview {
    Charts()
}

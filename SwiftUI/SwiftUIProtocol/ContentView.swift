import SwiftUI

protocol ColorThemeProtocol {
    // REQUIREMENTS
    var primary:Color {get}
    var secondary:Color {get}
    var teritary:Color {get}
}

struct DefaultColorTheme: ColorThemeProtocol{
    var primary: Color = .red
    
    var secondary: Color = .green
    
    var teritary: Color = .blue
    
    
}

struct AlternativeColorTheme: ColorThemeProtocol{
    var primary: Color = .primary
    
    var secondary: Color = .secondary
    
    var teritary: Color = .accentColor
    
}

protocol ButtonTextProtocol{
    var buttonText:String {get}
}

protocol ButtonPressedProtocol{
    func buttonPressed()
}

protocol ButtonDataSourceProtocol: ButtonTextProtocol,ButtonPressedProtocol{
    
}


class DefaultDataSource: ButtonDataSourceProtocol{
    
    var buttonText: String = "Protocols are awesome!"
    
    func buttonPressed() {
        print("Button Pressed")
    }
}

class AlternativeDataSource: ButtonDataSourceProtocol{
    var buttonText: String = "Protocols are really awesome!"
    
    func buttonPressed() {
        print("Again Button pressed")
    }
    
    
}



struct ContentView: View {
    
    @State var colorTheme: ColorThemeProtocol
    
    @State var dataSource: ButtonDataSourceProtocol
        
    var body: some View {
        ZStack {
            colorTheme.primary
                .ignoresSafeArea()
            
            VStack{
                Spacer()
                
                Text(dataSource.buttonText)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(colorTheme.secondary)
                    .padding()
                    .background()
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .onTapGesture {
                        dataSource.buttonPressed()
                    }
                
                
                Spacer()
                
                if dataSource is DefaultDataSource {
                    Text("Current ColorTheme is Default")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding()
                        .background()
                        .cornerRadius(10)
                    
                    
                    Text("Curret DataSource is Deafult")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding()
                        .background()
                        .cornerRadius(10)
                } else {
                    Text("Current ColorTheme is Alternative")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.pink)
                        .padding()
                        .background()
                        .cornerRadius(10)
                    
                    Text("Current DataSource is Alternative")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.pink)
                        .padding()
                        .background()
                        .cornerRadius(10)
                }
                
                Button {
                    if colorTheme is DefaultColorTheme {
                        colorTheme = AlternativeColorTheme()
                    } else {
                        colorTheme = DefaultColorTheme()
                    }
                    
                    
                    if dataSource is DefaultDataSource {
                        dataSource = AlternativeDataSource()
                    } else {
                        dataSource = DefaultDataSource()
                    }
                } label: {
                    Text("Change Button DataSource and Color Theme!")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding()
                        .background()
                        .cornerRadius(10)
                }
                Spacer()

            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(colorTheme: AlternativeColorTheme(), dataSource: DefaultDataSource())
    }
}

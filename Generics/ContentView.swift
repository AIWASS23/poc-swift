import SwiftUI

struct StringModel {
    
    let info: String?
    
    func removeInfo() -> StringModel{
        StringModel(info: nil)
    }
}

struct BoolModel {
    
    let info: Bool?
    
    func removeInfo() -> BoolModel {
        BoolModel(info: nil)
    }
}

struct GenericModel<T> {
    let info:T?
    
    func removeInfo() -> GenericModel {
        GenericModel(info: nil)
    }
}


struct GenericView <T:View> : View{
    
    var content: T
    var title:String
    
    var body: some View{
        VStack{
            content
            Text(title)
        }
    }
}


class ViewModel:ObservableObject {
    
    @Published var stringModel = StringModel(info: "Hello World")
    @Published var boolModel = BoolModel(info: true)
    @Published var genericStringModel = GenericModel(info: "Hello Generic")
    @Published var genericBoolModel = GenericModel(info: true)
    
    func removeData(){
        stringModel = stringModel.removeInfo()
        boolModel = boolModel.removeInfo()
        genericStringModel = genericStringModel.removeInfo()
        genericBoolModel = genericBoolModel.removeInfo()
    }
}



struct ContentView: View {
    
    @StateObject private var viewModel = ViewModel()
    var body: some View {
        VStack(spacing: 10) {
            Spacer()
            GenericView(content: PackMan(), title: "Generic View")
            Text(viewModel.stringModel.info ?? "No Data")
            Text(viewModel.boolModel.info?.description ?? "No Data")
            Text(viewModel.genericStringModel.info ?? "No Generic String")
            Text(viewModel.genericBoolModel.info?.description ?? "No Generic Bool")
        }
        .font(.headline)
        .onTapGesture {
            viewModel.removeData()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

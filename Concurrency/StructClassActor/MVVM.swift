import Foundation
import SwiftUI

actor StructClassActorDataManager {
    
    init() {
        print("StructClassActorDataManager Init")
    }
    
    deinit {
        print("StructClassActorDataManager Deinit")
    }
    
    func getDataFromDatabase() {
        
    }
    
}

class StructClassActorViewModel: ObservableObject{
    
    @Published var title:String = "MVVM"
    let manager: StructClassActorDataManager
    
    init(manager: StructClassActorDataManager) {
        self.manager = manager
        print("StructClassActorViewModel Init")
    }
    
    deinit {
        print("StructClassActorViewModel Deinit")
    }
    
}

struct StructClassActorView: View{
    
    @StateObject private var viewModel = StructClassActorViewModel(manager: StructClassActorDataManager())
    // -> ObservableObject class: Init ...
    // Even if this entire struct View would be re-rendered, its StateObject would be same
    // @ObservedObject private var viewModel = StructClassActorBootCampViewModel()
    // -> ObservableObject class: Init and Deinit ...
    let isActive:Bool
    
    init(isActive:Bool){
        self.isActive = isActive
        print("View Init, isActive : \(isActive)")
        /*
         View Init, isActive : true
         View Init, isActive : false
         View Init, isActive : true
         View Init, isActive : false
         ... -> Whenever isActive toggled, this View has been initiated.
         */
    }
    
    var body: some View{
        ZStack{
            Color.black.ignoresSafeArea()
            Text(viewModel.title)
                .font(.headline)
                .foregroundColor(.white)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                .background(isActive ? .pink : .purple)
        }
    }
}

struct StructClassActorHomeView: View {
    @State private var isActive:Bool = false
    var body: some View{
        StructClassActorView(isActive: isActive)
            .onTapGesture {
                isActive.toggle()
            }
        
        //MARK: - @StateObject
        /*
         View Init, isActive : false
         StructClassActorDataManager Init
         StructClassActorViewModel Init
         View Init, isActive : true
         View Init, isActive : false
         View Init, isActive : true
         View Init, isActive : false
         View Init, isActive : true
         View Init, isActive : false

         */
        
        //MARK: - @ObservedObject
        
        /*
         StructClassActorDataManager Init
         StructClassActorViewModel Init
         View Init, isActive : false
         StructClassActorDataManager Init
         StructClassActorViewModel Init
         View Init, isActive : true
         StructClassActorViewModel Deinit
         StructClassActorDataManager Deinit
         StructClassActorDataManager Init
         StructClassActorViewModel Init
         View Init, isActive : false
         StructClassActorViewModel Deinit
         StructClassActorDataManager Deinit
         StructClassActorDataManager Init
         StructClassActorViewModel Init
         View Init, isActive : true
         StructClassActorViewModel Deinit
         StructClassActorDataManager Deinit
         */
    }
}

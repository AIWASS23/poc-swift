import Foundation

class DoCatchTryThrowViewModel:ObservableObject{
    
    @Published var text:String = "Starting Text"
    var manager: DoCatchTryThrowProtocol
    
    init(manager: DoCatchTryThrowProtocol) {
        self.manager = manager
    }
    
    func getTitle(){
        guard let text = manager.getTitle() else {return }
        self.text = text
    }
    
    func getTitle2(){
        let returnedText = manager.getTitle2()
        if let text = returnedText.title{
            self.text = text
        }else if let error = returnedText.error?.localizedDescription{
            self.text = error
        }
    }
    
    func getTitle3(){
        let returnedText = manager.getTitle3()
        switch returnedText {
        case .success(let title):
            self.text = title
        case .failure(let error):
            self.text = error.localizedDescription
        }
    }
    
    func getTitle4(){
        do{
            self.text = try manager.getTitle4()
        }catch let error{
            self.text = error.localizedDescription
        }
    }
    
    func getTitle5(){
        guard let text = try? manager.getTitle5() else {
            self.text = DoCatchTryThrowErrors.getTitleError.localizedDescription
            return
        }
        self.text = text
    }
    
    func getTitle6(){
        do{
            self.text = try manager.getTitle4()
            self.text = try manager.getTitle5()
            // getTitle4 -> try success, getTitle5 -> try fail
            // then catch block
        }catch let error{
            self.text = error.localizedDescription
        }
    }
    
    func getTitle7(){
        do{
            if let text = try? manager.getTitle5(){
                self.text = text
            }
            
            self.text = try manager.getTitle4()
        }catch let error{
            self.text = error.localizedDescription
        }
    }
    
}

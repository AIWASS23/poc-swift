import Foundation

enum DoCatchTryThrowErrors: LocalizedError{
    case getTitleError
}

protocol DoCatchTryThrowProtocol{
    var isActive:Bool {get  set}
    func getTitle() -> String?
    func getTitle2() -> (title:String?,error:Error?)
    func getTitle3() -> Result<String,Error>
    func getTitle4() throws -> String
    func getTitle5() throws -> String
}

class DoCatchTryThrowDataManager:DoCatchTryThrowProtocol{

    var isActive: Bool = true
    
    let titleText:String = "Returned Text"
    
    func getTitle() -> String? {
        return isActive ? titleText : nil
    }
    
    func getTitle2() -> (title: String?, error: Error?) {
        return isActive ? (titleText, nil) : (nil, DoCatchTryThrowErrors.getTitleError)
    }
    
    func getTitle3() -> Result<String, Error> {
        return isActive ? .success(titleText) : .failure(DoCatchTryThrowErrors.getTitleError)
    }
    
    func getTitle4() throws -> String {
        if isActive{
            return titleText
        }else{
            throw DoCatchTryThrowErrors.getTitleError
        }
    }
    
    func getTitle5() throws -> String{
        throw DoCatchTryThrowErrors.getTitleError
    }
}

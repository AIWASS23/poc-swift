import Foundation

struct UserModel:Identifiable{
    let id = UUID().uuidString
    let name:String?
    let point:Int
    let isVerified:Bool
}

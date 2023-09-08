import Foundation
import SwiftUI

class TaskGroupViewModel: ObservableObject{
    
    @Published var images:[UIImage] = []
    let manager:TaskGroupDataProtocol
    let urlString:String
    
    init(manager: TaskGroupDataProtocol, urlString: String) {
        self.manager = manager
        self.urlString = urlString
    }
    
    func fetchImage() async{
        do{
            let image = try await manager.fetchImage(from: urlString)
            await MainActor.run{
                self.images.append(image)
            }
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func fetImagesWithAyncLet() async{
        do{
            let images = try await manager.fetImageWithAyncLet(from: urlString)
            await MainActor.run{
                self.images.append(contentsOf: images)
            }
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func fetImageWithTaskGroup() async{
        do{
            let images = try await manager.fetchImagesWithTaskGroup(from: urlString)
            await MainActor.run{
                self.images.append(contentsOf: images)
            }
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func fetImageWithTaskGroupNumber(number: Int) async{
        do{
            let images = try await manager.fetchImagesWithTaskGroupWithNumber(from: urlString, number: number)
            await MainActor.run{
                self.images.append(contentsOf: images)
            }
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func fetchImagesWithTaskGroupWithNumberWithOptional(number: Int) async{
        do{
            let images = try await manager.fetchImagesWithTaskGroupWithNumberWithOptional(from: urlString, number: number)
            await MainActor.run{
                self.images.append(contentsOf: images)
            }
        }catch{
            print(error.localizedDescription)
        }
    }
}

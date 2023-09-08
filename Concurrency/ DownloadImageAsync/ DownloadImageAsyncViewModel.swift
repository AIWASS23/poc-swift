import Foundation
import SwiftUI
import Combine

class DownloadImageAsyncViewModel: ObservableObject{
    
    @Published var image:UIImage? = nil
    let dataServices = DownloadImageAsyncServices(url: "https://picsum.photos/200")
    var cancellables = Set<AnyCancellable>()
    
    func fetchImagesWithComplpetionClousure(){
        dataServices.downloadWithEscaping { [weak self] image, error in
            if let error = error{
                print(error.localizedDescription)
            }else{
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else {return}
                    self.image = image
                }
            }
        }
    }
    
    func fetImagesWithCombine(){
        dataServices.downloadWithCombine()
            .sink { completion in
                switch completion{
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] image in
                guard let self = self else {return}
                DispatchQueue.main.async {
                    self.image = image
                }
            }
            .store(in: &cancellables)
    }
    
    func fetImagesWithCombine2(){
        dataServices.downloadWithCombine()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion{
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    break
                }
            } receiveValue: { [weak self] image in
                guard let self = self else {return}
                self.image = image
            }
            .store(in: &cancellables)
    }
    
    func fetImagesWithAsync() async{
        do{
            guard let image = try await dataServices.downloadImageWithAsync() else {return}
            await MainActor.run{
                self.image = image
            }
            
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func fetImagesWithTask(){
        Task{
            await fetImagesWithAsync()
        }
    }
    
    
}

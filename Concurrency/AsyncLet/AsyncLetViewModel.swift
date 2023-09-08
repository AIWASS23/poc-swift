import Foundation
import SwiftUI

class AsyncLetViewModel: ObservableObject{
    
    @Published var images:[UIImage] = []
    @Published var title:String = "Aync Let 😍"
    
    func getUrl() -> URL?{
        guard let url = URL(string: "https://picsum.photos/200") else {return nil}
        return url
    }
    
    func fetImage() async throws -> UIImage{
        do{
            guard let url = getUrl() else {throw URLError(.badURL)}
            
            let (data,_ ) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else {
                throw URLError(.badURL)
            }
            return image
        }catch{
            throw error
        }
    }
    
    func fetchTitle() async -> String{
        return "Title"
    }
    
    func fetImageSingleTask(){
        Task{
            let image1 = try await fetImage()
            await MainActor.run{
                self.images.append(image1)
            }
            
            
            let image2 = try await fetImage()
            await MainActor.run{
                self.images.append(image2)
            }
            
            let image3 = try await fetImage()
            await MainActor.run{
                self.images.append(image3)
            }
            
            let image4 = try await fetImage()
            await MainActor.run{
                self.images.append(image4)
            }
        }
    }
    
    func fetImageMultipleTask(){
        Task{
            let image1 = try await fetImage()
            await MainActor.run{
                self.images.append(image1)
            }
        }
        
        Task{
            let image2 = try await fetImage()
            await MainActor.run{
                self.images.append(image2)
            }
        }
        
        Task{
           let image3 = try await fetImage()
            await MainActor.run{
                self.images.append(image3)
            }
        }
        
        Task{
            let image4 = try await fetImage()
            await MainActor.run{
                self.images.append(image4)
            }
        }
    }
    
    func fetImagesAsyncLet(){
        Task{
            do{
                async let fetImage1 = fetImage()
                async let fetImage2 = fetImage()
                async let fetImage3 = fetImage()
                async let fetImage4 = fetImage()
                
                let (image1,image2,image3,image4) = try await (fetImage1,fetImage2,fetImage3,fetImage4)
                let images = [image1,image2,image3,image4]
                await MainActor.run{
                    self.images.append(contentsOf: images)
                }
            }catch{
                print(error.localizedDescription)
            }
        }
    }
    
    func fetImagesAsyncLet2(){
        Task{
            do{
                async let fetImage = fetImage()
                async let fetTitle = fetchTitle()
                let (image,title) = await (try fetImage,fetTitle)
                await MainActor.run{
                    self.images.append(image)
                    self.title = title
                }
            }catch{
                print(error.localizedDescription)
            }
        }
    }
}

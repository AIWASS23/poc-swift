import SwiftUI

class CheckedContinuationViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    let dataService: CheckedContinuationProtocol
    let urlString: String
    let url: URL
    
    init(dataService: CheckedContinuationProtocol, urlString: String) {
        self.dataService = dataService
        self.urlString = urlString
        if let url = URL(string: urlString) {
            self.url = url
        } else {
            self.url = URL(string: "https://picsum.photos/1000")!
        }
    }
    
    func fetchImage() async {
        do {
            let data = try await dataService.fetchData(url: url)
            if let image = UIImage(data: data) {
                await MainActor.run(body: {
                    self.image = image
                })
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchImage2() async {
        do {
            let data = try await dataService.fetchData2(url: url)
            if let image = UIImage(data: data) {
                await MainActor.run(body: {
                    self.image = image
                })
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchImageFromDatabase() async {
        do {
            let image = try await dataService.fetchDataFromDatabase()
            await MainActor.run(body: {
                self.image = image
            })
        } catch {
            print(error.localizedDescription)
        }
    }
}

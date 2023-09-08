import Foundation
import SwiftUI

class TasksViewModel: ObservableObject {
    
    @Published var image:UIImage? = nil
    @Published var image2:UIImage? = nil
    
    func getUrl() -> URL?{
        guard let url = URL(string: "https://picsum.photos/200") else {return nil}
        return url
    }
    
    
    func fetImage() async{
        do {
            guard let url = getUrl() else {return}
            let (data,_) = try await URLSession.shared.data(from: url)
            await MainActor.run{
                image = UIImage(data: data)
            }
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func fetImage2() async{
        do{
            guard let url = getUrl() else {return}
            let (data,_) = try await URLSession.shared.data(from: url)
            await MainActor.run{
                image2 = UIImage(data: data)
            }
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func printTaskPriority(){
        Task(priority: .high) {
            print("high: \(Thread.current) : \(Task.currentPriority)")
        }
        
        Task(priority: .medium) {
            print("medium: \(Thread.current) : \(Task.currentPriority)")
        }
        
        Task(priority: .low) {
            print("low: \(Thread.current) : \(Task.currentPriority)")
        }
        
        Task(priority: .background) {
            print("background: \(Thread.current) : \(Task.currentPriority)")
        }
        
        Task(priority: .utility) {
            print("utility: \(Thread.current) : \(Task.currentPriority)")
        }
        
        Task(priority: .userInitiated) {
            print("userInitiated: \(Thread.current) : \(Task.currentPriority)")
        }
    }
    
    /*
     high: <NSThread: 0x600000b8cd00>{number = 8, name = (null)} : TaskPriority(rawValue: 25)
     userInitiated: <NSThread: 0x600000b8cd00>{number = 8, name = (null)} : TaskPriority(rawValue: 25)
     medium: <NSThread: 0x600000bbb480>{number = 7, name = (null)} : TaskPriority(rawValue: 21)
     low: <NSThread: 0x600000bacc80>{number = 4, name = (null)} : TaskPriority(rawValue: 17)
     utility: <NSThread: 0x600000bacc80>{number = 4, name = (null)} : TaskPriority(rawValue: 17)
     background: <NSThread: 0x600000bbb480>{number = 7, name = (null)} : TaskPriority(rawValue: 9)
     */
    
    func printTaskPriority2(){
        Task(priority: .high) {
            try? await Task.sleep(nanoseconds:2_000_000_000)
            //await Task.yield()
            print("high: \(Thread.current) : \(Task.currentPriority)")
        }
        
        Task(priority: .medium) {
            print("medium: \(Thread.current) : \(Task.currentPriority)")
        }
        
        Task(priority: .low) {
            print("low: \(Thread.current) : \(Task.currentPriority)")
        }
        
        Task(priority: .background) {
            print("background: \(Thread.current) : \(Task.currentPriority)")
        }
        
        Task(priority: .utility) {
            print("utility: \(Thread.current) : \(Task.currentPriority)")
        }
        
        Task(priority: .userInitiated) {
            print("userInitiated: \(Thread.current) : \(Task.currentPriority)")
        }
    }
    
    // MARK: - await Task.yield()
    
    /*
     userInitiated: <NSThread: 0x6000014be080>{number = 3, name = (null)} : TaskPriority(rawValue: 25)
     medium: <NSThread: 0x6000014d9400>{number = 7, name = (null)} : TaskPriority(rawValue: 21)
     low: <NSThread: 0x6000014f0400>{number = 8, name = (null)} : TaskPriority(rawValue: 17)
     utility: <NSThread: 0x6000014f0400>{number = 8, name = (null)} : TaskPriority(rawValue: 17)
     high: <NSThread: 0x6000014be080>{number = 3, name = (null)} : TaskPriority(rawValue: 25)
     background: <NSThread: 0x6000014d9400>{number = 7, name = (null)} : TaskPriority(rawValue: 9)
     */
    
    // MARK: - try? await Task.sleep(nanoseconds:2_000_000_000)
    
    /*
     userInitiated: <NSThread: 0x600003848280>{number = 6, name = (null)} : TaskPriority(rawValue: 25)
     low: <NSThread: 0x60000385c040>{number = 9, name = (null)} : TaskPriority(rawValue: 17)
     medium: <NSThread: 0x600003870000>{number = 8, name = (null)} : TaskPriority(rawValue: 21)
     utility: <NSThread: 0x60000385c040>{number = 9, name = (null)} : TaskPriority(rawValue: 17)
     background: <NSThread: 0x60000381c440>{number = 10, name = (null)} : TaskPriority(rawValue: 9)
     high: <NSThread: 0x6000038444c0>{number = 12, name = (null)} : TaskPriority(rawValue: 25)
     */
    
    func printParentChildTask(){
        Task(priority: .low) {
            print("parent: \(Thread.current) : \(Task.currentPriority)")
            
            Task{
                print("child: \(Thread.current) : \(Task.currentPriority)")
            }
            
            Task.detached(priority: .high) {
                print("child detached \(Thread.current) : \(Task.currentPriority)")
            }
        }
    }
    
    /*
     parent: <NSThread: 0x6000009b4740>{number = 5, name = (null)} : TaskPriority(rawValue: 17)
     child detached <NSThread: 0x6000009ec3c0>{number = 6, name = (null)} : TaskPriority(rawValue: 25)
     child: <NSThread: 0x6000009b4740>{number = 5, name = (null)} : TaskPriority(rawValue: 17)
     */
    
    func resetImage(){
        image = nil
        image2 = nil
    }
}

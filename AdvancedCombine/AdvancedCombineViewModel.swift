import Foundation
import Combine

class AdvancedCombineViewModel: ObservableObject {
    
    @Published var data:[String] = []
    @Published var dataBools:[Bool] = []
    @Published var error:String = ""
    let dataServices = AdvancedCombineDataServices()
    var cancellables = Set<AnyCancellable>()
    let multicastPublisher = PassthroughSubject<Int,Error>()
    
    init(){
       addSubscribers()
    }
    
    private func addSubscribers(){
       // dataServices.$basicPublisher
       // dataServices.currentValuePublisher
       // dataServices.passThroughPublisher
        
// MARK: - Sequence Operations
        /*
            // 1 - Publish the first element of the stream and then finish
            //.first()
        
            // 2 - Publishes the first element of a stream to satisfy a predicate closure, then finishes normally.
            //.first(where: {$0 > 4})
        
            // 3 - Publishes the first element of a stream to satisfy a throwing predicate closure, then finishes normally.
//            .tryFirst(where: { int in
//                if int == 3{
//                    throw URLError(.badServerResponse)
//                }
//                return int > 4
//            })
        
            // 4 - Publishes the last element of a stream, after the stream finishes.
            //.last()
        
            // 5 - Publishes the last element of a stream that satisfies a predicate closure, after upstream finishes.
            //.last(where: {$0 > 4})
        
            // 6 - Publishes the last element of a stream that satisfies an error-throwing predicate closure, after the stream finishes.
//            .tryLast(where: { int in
//                if int == 3{
//                    throw URLError(.badServerResponse)
//                }
//                return int > 1
//            })
        
            // 7 - Omits the specified number of elements before republishing subsequent elements.
           // .dropFirst()
        
            // 8 - Omits the specified number of elements before republishing subsequent elements.
            //.dropFirst(3)
        
            // 9 - Omits elements from the upstream publisher until a given closure returns false, before republishing all remaining elements.
            //.drop(while: {$0 < 5})
        
            // 10 - Omits elements from the upstream publisher until an error-throwing closure returns false, before republishing all remaining elements.
//            .tryDrop(while: { int in
//                if int == 9{
//                    throw URLError(.badServerResponse)
//                }
//
//                return int < 6
//            })
        
            // 11 - Republishes elements up to the specified maximum count.
            //.prefix(4)
            
            // 12 - Republishes elements while a predicate closure indicates publishing should continue.
            //.prefix(while: {$0 < 5})
        
            // 13 - Republishes elements while an error-throwing predicate closure indicates publishing should continue.
//            .tryPrefix(while: { int in
//                if int  == 3{
//                    throw URLError(.badServerResponse)
//                }
//
//                return int < 4
//            })
        
            // 14 - Publishes a specific element, indicated by its index in the sequence of published elements.
            //.output(at: 1)
        
            // 15 - Publishes elements specified by their range in the sequence of published elements.
           // .output(in: 2..<4)
        */
        
// MARK: - Mathematic Operation
        /*
        
        ///1 - Publishes the maximum value received from the upstream publisher, after it finishes.
           // .max()
        
        ///2 - Publishes the maximum value received from the upstream publisher, using the provided ordering closure.
//            .max(by: { int1, int2 in
//                return int1 < int2
//            })
        
        ///3 - tryMax
//            .tryMax(by: { int1, int2 in
//                return int1 > int2
//            })
        
        ///4 - min
            //.min()
        
        ///5 - min(by
//            .min(by: { int1, int2 in
//                return int1 < int2
//            })
        
        ///6. tryMin
//            .tryMin(by: { int1, int2 in
//                if int1 > int2{
//                    throw URLError(.badServerResponse)
//                }
//                return int1 < int2
//            })
        
        */
        
// MARK: - Filtering / Reducing Operations
        /*
         ///1 - Transforms all elements from the upstream publisher with a provided closure.
            //.map({String($0)})
        
         ///2 - Transforms all elements from the upstream publisher with a provided error-throwing closure.
//            .tryMap({ int in
//                if int == 5{
//                    throw URLError(.badServerResponse)
//                }
//                return String(int)
//            })
        
         ///3 - Calls a closure with each received element and publishes any returned optional that has a value.
//            .compactMap({ int -> String? in
//                if int == 5{
//                    return nil
//                }
//                return String(int)
//            })
        
         ///4 - Calls an error-throwing closure with each received element and publishes any returned optional that has a value.
//            .tryCompactMap({ int -> String in
//                if int == 5{
//                    throw URLError(.badServerResponse)
//                }
//                return String(int)
//            })
        
         ///5 - Republishes all elements that match a provided closure.
            //.filter{$0 > 3 && $0 < 9}
        
        ///6 - Republishes all elements that match a provided error-throwing closure.
//            .tryFilter({ int in
//                if int == 5{
//                    throw URLError(.badServerResponse)
//                }
//                return int > 1 && int < 10
//            })
        
        ///7 - removeDuplicates
            //.removeDuplicates()
        
        ///8 - Publishes only elements that don’t match the previous element, as evaluated by a provided closure.
//            .removeDuplicates(by: { int1, int2 in
//                return int1 == int2
//            })
        
        ///9 - Publishes only elements that don’t match the previous element, as evaluated by a provided error-throwing closure.
//            .tryRemoveDuplicates(by: { int1, int2 in
//                if int1 == int2{
//                    throw URLError(.badServerResponse)
//                }
//
//                return int1 == int2
//            })
        
        ///10 - replaceNil
           // .replaceNil(with: 2)
        
        ///11 - replaceEmpty
            //.replaceEmpty(with: 0)
        
        ///12 - replaceError
            //.replaceError(with: "No More Error")
        
        ///13 - Transforms elements from the upstream publisher by providing the current element to a closure along with the last value returned by the closure.
//            .scan(0, { existingValue, newValue in
//                return existingValue + newValue
//            })
            //.scan(0, {$0 + $1})
            //.scan(0, +)
        
        ///14 - Transforms elements from the upstream publisher by providing the current element to an error-throwing closure along with the last value returned by the closure.
//            .tryScan(0, { existingValue, newValue in
//                if newValue == 3{
//                    throw URLError(.badServerResponse)
//                }
//                return existingValue + newValue
//            })
        
        ///15 - Applies a closure that collects each element of a stream and publishes a final result upon completion.
//            .reduce(0, { existingValue, newValue in
//                return existingValue + newValue
//            })
        
            //.reduce(0, {$0 + $1})
            //.reduce(0, +)
        
        ///16 - Collects all received elements, and emits a single array of the collection when the upstream publisher finishes.
//            .map({String($0)})
//            .collect()
        
        ///17 - Collects up to the specified number of elements, and then emits a single array of the collection.
//            .map({String($0)})
//            .collect(4)
//
        
        ///18 - Publishes a single Boolean value that indicates whether all received elements pass a given predicate.
            //.allSatisfy({$0 < 20})
        
        ///19 - Publishes a single Boolean value that indicates whether all received elements pass a given error-throwing predicate.
            .tryAllSatisfy({ int in
                if int == 5{
                    throw URLError(.badServerResponse)
                }
                return int < 10
            })
        
        */
        
// MARK: - Timing Operations
        /*
        ///1 - Publishes elements only after a specified time interval elapses between events.
            //.debounce(for: 0.75, scheduler: DispatchQueue.main)
        
        ///2 - Delays delivery of all output to the downstream receiver by a specified amount of time on a particular scheduler.
            //.delay(for: 2, scheduler: DispatchQueue.main)
        
        ///3 - Measures and emits the time interval between events received from an upstream publisher.
//            .measureInterval(using: DispatchQueue.main)
//            .map({stride in
//                return "\(stride.timeInterval)"
//            })
        
        ///4 - Publishes either the most-recent or first element published by the upstream publisher in the specified time interval.
           // .throttle(for: 5, scheduler: DispatchQueue.main, latest: true)
        
        ///5 - Attempts to recreate a failed subscription with the upstream publisher up to the number of times you specify.
           //.retry(3)
        
        ///6 - Terminates publishing if the upstream publisher exceeds the specified time interval without producing an element.
            .timeout(0.75, scheduler: DispatchQueue.main)
        
        */
        
// MARK: - Multiple Publishers / Subscribers
        /*
        ///1 - Subscribes to an additional publisher and publishes a tuple upon receiving output from either publisher.
            //.combineLatest(dataServices.boolPublisher,dataServices.intPublisher)
//            .compactMap({(Int,Bool) in
//                if Bool{
//                    return String(Int)
//                }
//                return nil
//            })
            //.compactMap({$1 ? String($0) : "n/a"})
//            .compactMap({ (int1, bool, int2) in
//                if bool{
//                    return String(int1)
//                }
//                return "n/a"
//            })
            //.removeDuplicates()
        
        ///2 - Combines elements from this publisher with those from another publisher of the same type, delivering an interleaved sequence of elements.
            //.merge(with: dataServices.intPublisher)
        
        ///3 - Combines elements from another publisher and deliver pairs of elements as tuples.
//            .zip(dataServices.boolPublisher, dataServices.intPublisher)
//            .map({ tuple in
//                return String(tuple.0) + tuple.1.description + String(tuple.2)
//            })
        
        ///4 - Transforms all elements from the upstream publisher with a provided error-throwing closure.
//            .tryMap({ int in
//                if int == 5{
//                    throw URLError(.badServerResponse)
//                }
//                return int
//            })
//            .catch({ error in
//                return self.dataServices.intPublisher
//            })
        */
        

        let sharedPublisher =  dataServices.passThroughPublisher
            //.dropFirst(3)
            .share()
//            .multicast {
//                PassthroughSubject<Int,Error>()
//            }
            .multicast(subject: multicastPublisher)
        
        sharedPublisher
            .map({String($0)})
            .sink { [weak self] completion in
                guard let self = self else {return}
                switch completion{
                case .finished:
                    break
                case .failure(let error):
                    self.error = "Error:- \(error.localizedDescription)"
                    break
                }
            } receiveValue: { [weak self] returnedData in
                guard let self = self else {return}
               //self.data = returnedData
                self.data.append(returnedData)
            }
            .store(in: &cancellables)
        
        sharedPublisher
            .map({$0 > 5 ? true : false})
            .sink { [weak self] completion in
                guard let self = self else {return}
                switch completion{
                case .finished:
                    break
                case .failure(let error):
                    self.error = "Error:- \(error.localizedDescription)"
                    break
                }
            } receiveValue: { [weak self] returnedData in
                guard let self = self else {return}
               //self.data = returnedData
                self.dataBools.append(returnedData)
            }
            .store(in: &cancellables)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5){
            sharedPublisher
                .connect()
                .store(in: &self.cancellables)
        }
    }
}


import XCTest
@testable import UnitTestsPractice
import Combine

final class MockDataServiceTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_MocksDataService_init_doesSetValuesCorrectly(){
        
        // Given
        let items1:[String]? = nil
        let items2:[String]? = []
        let items3:[String]? = [UUID().uuidString,UUID().uuidString,UUID().uuidString]
        
        // When
        let dataService = MockDataServices(item: items1)
        let dataService2 = MockDataServices(item: items2)
        let dataService3 = MockDataServices(item: items3)
        
        // Then
        XCTAssertFalse(dataService.item.isEmpty)
        XCTAssertTrue(dataService2.item.isEmpty)
        XCTAssertEqual(dataService3.item.count, items3?.count)
        
    }
    
    func test_MocksDataService_downloadDataWithEscaping_doesSetValuesCorrectly(){
        
        // Given
       let dataService = MockDataServices(item: nil)
        
        // When
        var items:[String] = []
        let expectation = XCTestExpectation()
        dataService.downloadDataWithEscaping { returnedItems in
            items = returnedItems
            expectation.fulfill()
        }
       
        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(items.count, dataService.item.count)
        XCTAssertTrue(!dataService.item.isEmpty)
        
    }
    
    func test_MocksDataService_downloadDatawithCombine_doesSetValuesCorrectly(){
        
        // Given
       let dataService = MockDataServices(item: nil)
        
        // When
        var items:[String] = []
        let expectation = XCTestExpectation()
        dataService.downloadDatawithCombine()
            .sink { completion in
                
                switch completion{
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail()
                }
                
            } receiveValue: { returnedItems in
                items = returnedItems
            }
            .store(in: &cancellables)

       
        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(items.count, dataService.item.count)
        XCTAssertTrue(!dataService.item.isEmpty)
        
    }
    
    func test_MocksDataService_downloadDatawithCombine_doesFail(){
        
        // Given
       let dataService = MockDataServices(item: [])
        
        // When
        var items:[String] = []
        let expectation = XCTestExpectation(description: "Does thow a error")
        let expectation2 = XCTestExpectation(description: "Does thow a URLError.badServerResponse")
        dataService.downloadDatawithCombine()
            .sink { completion in
                
                switch completion{
                case .finished:
                    XCTFail()
                case .failure(let error):
                    expectation.fulfill()
//                    let urlError = error as? URLError
//                    XCTAssertEqual(urlError, URLError(.badServerResponse))
                    
                    if error as? URLError == URLError(.badServerResponse){
                        expectation2.fulfill()
                    }
                }
                
            } receiveValue: { returnedItems in
                items = returnedItems
            }
            .store(in: &cancellables)

       
        // Then
        wait(for: [expectation,expectation2], timeout: 5)
        
        XCTAssertEqual(items.count, dataService.item.count)
       
    }

}

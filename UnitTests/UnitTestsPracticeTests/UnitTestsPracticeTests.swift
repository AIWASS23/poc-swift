import XCTest
@testable import UnitTestsPractice
import Combine

final class UnitTestsPracticeTests: XCTestCase {
    
    var viewModel: UnitTestsViewModel?
    
    var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = UnitTestsViewModel(isPremium: Bool.random())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }
    
    func test_unitTestsViewModel_isPremium_shouldBeTrue(){
        // Given
        let isPremium:Bool = true
        
        // When
        let viewModel = UnitTestsViewModel(isPremium: isPremium)
        
        // Then
        XCTAssertTrue(viewModel.isPremium)
    }
    
    func test_unitTestsViewModel_isPremium_shouldBeFalse(){
        
        // Given
        let isPremium:Bool = false
        
        // When
        let viewModel = UnitTestsViewModel(isPremium: isPremium)
        
        // Then
        XCTAssertFalse(viewModel.isPremium)
    }
    
    func test_unitTestsViewModel_selectedItem_shouldBeSelected_stress(){
        // Given
        let viewModel = UnitTestsViewModel(isPremium: Bool.random())
        
        // When
        let loopCount = Int.random(in: 0..<100)
        var itemsArray:[String] = []
        
        for _ in 0..<loopCount{
            let newItem = UUID().uuidString
            viewModel.addItem(item: newItem)
            itemsArray.append(newItem)
        }
        let randomItem = itemsArray.randomElement() ?? ""
        XCTAssertFalse(randomItem.isEmpty)
        viewModel.selectedItem(item: randomItem)
        
        // Then
        XCTAssertNotNil(viewModel.selectedItem)
        XCTAssertEqual(randomItem, viewModel.selectedItem)
    }

   
    func test_unitTestsViewModel_saveItem_shouldThrows_itemNotFound(){
        // Given
        let viewModel = UnitTestsViewModel(isPremium: Bool.random())
        
        // When
        let loopCount = Int.random(in: 0..<100)
        
        for _ in 0..<loopCount{
            viewModel.addItem(item: UUID().uuidString)
        }
        
        // Then
        XCTAssertThrowsError(try viewModel.saveItem(item: UUID().uuidString))
        
        XCTAssertThrowsError(try viewModel.saveItem(item: UUID().uuidString),"Should Return DataError"){ error in
            let returnedError = error as? UnitTestsViewModel.DataError
            
            XCTAssertEqual(returnedError, UnitTestsViewModel.DataError.itemNotFound)
        }
    }
    
    func test_unitTestsViewModel_saveItem_shouldThrows_noDataError(){
        // Given
        let viewModel = UnitTestsViewModel(isPremium: Bool.random())
        
        // When
        let loopCount = Int.random(in: 0..<100)
        for _ in 0..<loopCount{
            viewModel.addItem(item: UUID().uuidString)
        }
        
        // Then
        do{
            try viewModel.saveItem(item: "")
        }catch let error{
            let returnedError = error as? UnitTestsViewModel.DataError
            XCTAssertEqual(returnedError, UnitTestsViewModel.DataError.noData)
        }
    }
    
    func test_unitTestingViewModel_saveItem_shouldNotThrow(){
        // Given
        let viewModel = UnitTestsViewModel(isPremium: Bool.random())
        
        // When
        let loopCount = Int.random(in: 0..<100)
        var itemArray:[String] = []
        
        for _ in 0..<loopCount{
            let newItem = UUID().uuidString
            viewModel.addItem(item: newItem)
            itemArray.append(newItem)
        }
        let randomItem = itemArray.randomElement() ?? ""
        XCTAssertFalse(randomItem.isEmpty)
        
        // Then
        XCTAssertNoThrow(try viewModel.saveItem(item: randomItem))
        
        do{
            try viewModel.saveItem(item: randomItem)
        }catch{
            XCTFail()
        }
    }
    
    func test_unitTestingViewModel_downloadWithEscaping_shouldReturnItems(){
        // Given
        let viewModel = UnitTestsViewModel(isPremium: Bool.random())
        
        // When
        let expectation = XCTestExpectation(description: "Should return data after 3 seconds")
        
        viewModel.$dataArray
            .dropFirst()
            .sink { returnedValues in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.downloadWithEscaping()
        
        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertGreaterThan(viewModel.dataArray.count, 0)
    }
    
    func test_unitTestingViewModel_downloadWithCombine_shouldReturnItems(){
        // Given
        let viewModel = UnitTestsViewModel(isPremium: Bool.random())
        
        // When
        let expectation = XCTestExpectation(description: "Should return data after 3 seconds")
        
        viewModel.$dataArray
            .dropFirst()
            .sink { returnedValues in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.downloadWithCombine()
        
        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertGreaterThan(viewModel.dataArray.count, 0)
    }
    
    func test_UnitTestingViewModel_downloadWithCombine_shouldReturnItems2() {
           // Given
           let items = Array(repeating: UUID().uuidString, count: 5)
           let dataService: DataServicesProtocol = MockDataServices(item: items)
           let viewModel = UnitTestsViewModel(isPremium: Bool.random(), dataService: dataService)
           
           // When
           let expectation = XCTestExpectation(description: "Should Return Items after a seconds")
           viewModel.$dataArray
               .dropFirst()
               .sink { returnedItems in
                   // Extepctation Observer
                   expectation.fulfill()
               }
               .store(in: &cancellables)
           viewModel.downloadWithCombine()

           // Then
           wait(for: [expectation], timeout: 1.0)
           XCTAssertGreaterThan(viewModel.dataArray.count, 0)
           XCTAssertEqual(viewModel.dataArray.count, items.count)
       }
}

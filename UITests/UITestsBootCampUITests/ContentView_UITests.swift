import XCTest

// Naming Structure: test_UnitOfWork_StateUnderTest_ExpectedBehaviour
// Naming Structures: test_[Structure]_[UI component]_[expected result]
// Tesing Structures: Given, When, Then

//final class ContentView_UITests: XCTestCase {
//
//    let app = XCUIApplication()
//
//    override func setUpWithError() throws {
//        continueAfterFailure = false
//        app.launch()
//    }
//
//    override func tearDownWithError() throws {
//    }
//
//    func test_contentView_signupButton_shouldNotSignIn(){
//        // Given
//        let textField = app.textFields["SignUpTextField"]
//
//        // When
//        textField.tap()
//
//        let signUpButton = app.buttons["SignUpButton"]
//        signUpButton.tap()
//
//        let navBar = app.navigationBars["Welcome!"]
//
//        // Then
//        XCTAssertFalse(navBar.exists)
//
//    }
//
//    func test_contentView_signupButton_shouldSignIn(){
//
//        // Given
//        let textField = app.textFields["SignUpTextField"]
//
//        // When
//        textField.tap()
//        textField.typeText("Qwerty")
//
//        let returnButton = app.buttons["Return"]
//        returnButton.tap()
//
//        let signUpButton = app.buttons["SignUpButton"]
//        signUpButton.tap()
//
//        let navBar = app.navigationBars["Welcome!"]
//
//        // Then
//        XCTAssertTrue(navBar.exists)
//    }
//
//
//    func test_SignedInView_showAlertButton_shouldDisplayAlert(){
//        // Given
//        let textField = app.textFields["SignUpTextField"]
//
//        // When
//        textField.tap()
//        textField.typeText("Qwerty")
//
//        let returnButton = app.buttons["Return"]
//        returnButton.tap()
//
//        let signUpButton = app.buttons["SignUpButton"]
//        signUpButton.tap()
//
//        let navBar = app.navigationBars["Welcome!"]
//        XCTAssertTrue(navBar.exists)
//
//        let showAlertButton = app.buttons["ShowAlertButton"]
//        showAlertButton.tap()
//
//        let alert = app.alerts.firstMatch
//
//        // Then
//        XCTAssertTrue(alert.exists)
//
//    }
//
//    func test_SignedInView_showAlertButton_shouldDisplayAlertAndDismiss(){
//        // Given
//        let textField = app.textFields["SignUpTextField"]
//
//        // When
//        textField.tap()
//        textField.typeText("Qwerty")
//
//        let returnButton = app.buttons["Return"]
//        returnButton.tap()
//
//        let signUpButton = app.buttons["SignUpButton"]
//        signUpButton.tap()
//
//        let navBar = app.navigationBars["Welcome!"]
//        XCTAssertTrue(navBar.exists)
//
//        let showAlertButton = app.buttons["ShowAlertButton"]
//        showAlertButton.tap()
//
//        let alert = app.alerts.firstMatch
//        XCTAssertTrue(alert.exists)
//
//        let alertOkButton = alert.buttons["OK"]
//        //XCTAssertTrue(alertOkButton.exists)
//
//        let alertOkButtonExists = alertOkButton.waitForExistence(timeout: 5)
//        XCTAssertTrue(alertOkButtonExists)
//
//        // sleep(1)
//        alertOkButton.tap()
//        // sleep(1)
//
//        let alertExists = alert.waitForExistence(timeout: 5)
//        XCTAssertFalse(alertExists)
//
//        // Then
//        XCTAssertFalse(alert.exists)
//
//    }
//
//    func test_SignedInView_navigationLinkToDestination_shouldNavigateToDestination(){
//        // Given
//        let textField = app.textFields["SignUpTextField"]
//
//        // When
//        textField.tap()
//        textField.typeText("Qwerty")
//
//        let returnButton = app.buttons["Return"]
//        returnButton.tap()
//
//        let signUpButton = app.buttons["SignUpButton"]
//        signUpButton.tap()
//
//        let navBar = app.navigationBars["Welcome!"]
//        XCTAssertTrue(navBar.exists)
//
//        let naviagateButton = app.buttons["navigationLinkToDestinatio"]
//        naviagateButton.tap()
//
//        let destinationText = app.staticTexts["Destination"]
//
//        // Then
//        XCTAssertTrue(destinationText.exists)
//
//    }
//
//    func test_SignedInView_navigationLinkToDestination_shouldNavigateToDestinationAndGoBack(){
//        // Given
//        let textField = app.textFields["SignUpTextField"]
//
//        // When
//        textField.tap()
//        textField.typeText("Qwerty")
//
//        let returnButton = app.buttons["Return"]
//        returnButton.tap()
//
//        let signUpButton = app.buttons["SignUpButton"]
//        signUpButton.tap()
//
//        let navBar = app.navigationBars["Welcome!"]
//        XCTAssertTrue(navBar.exists)
//
//        let naviagateButton = app.buttons["navigationLinkToDestinatio"]
//        naviagateButton.tap()
//
//        let destinationText = app.staticTexts["Destination"]
//        XCTAssertTrue(destinationText.exists)
//
//        let backButton = app.navigationBars.buttons["Welcome!"]
//        backButton.tap()
//
//        // Then
//        XCTAssertTrue(navBar.exists)
//    }
//}

final class ContentView_UITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        // Arguments
        //app.launchArguments = ["-UITest_StartSignedIn"]
        
        //Environment
        //app.launchEnvironment = ["-UITest_StartSignedIn2": "true"]
        app.launch()
    }
    
    override func tearDownWithError() throws {
        
    }
    
    func test_contentView_signupButton_shouldNotSignIn(){
        // Given
        signUpandSignIn(shouldTypeOnKeyboard: false)
        
        // When
        let navBar = app.navigationBars["Welcome!"]
        
        // Then
        XCTAssertFalse(navBar.exists)
        
    }
    
    func test_contentView_signupButton_shouldSignIn(){
        
        // Given
        signUpandSignIn(shouldTypeOnKeyboard: true)
        
        // When
        let navBar = app.navigationBars["Welcome!"]
        
        // Then
        XCTAssertTrue(navBar.exists)
    }
    
    func test_SignedInView_showAlertButton_shouldDisplayAlert(){
        // Given
        signUpandSignIn(shouldTypeOnKeyboard: true)
        
        // When
        tapAlertButton(shouldDismissAlert: false)
        
        // Then
        let alert = app.alerts.firstMatch
        XCTAssertTrue(alert.exists)
        
    }
    
    func test_SignedInView_showAlertButton_shouldDisplayAlertAndDismiss(){
        // Given
        signUpandSignIn(shouldTypeOnKeyboard: true)
        
        // When
        tapAlertButton(shouldDismissAlert: true)
                
        // Then
        let alertExists = app.alerts.firstMatch.waitForExistence(timeout: 5)
        XCTAssertFalse(alertExists)
    }
    
    
    func test_SignedInView_navigationLinkToDestination_shouldNavigateToDestination(){
        // Given
        signUpandSignIn(shouldTypeOnKeyboard: true)
        
        // When
       tapNavigationLink(shouldDismissDestination: false)
                
        // Then
        let destinationText = app.staticTexts["Destination"]
        XCTAssertTrue(destinationText.exists)
    }

    
    func test_SignedInView_navigationLinkToDestination_shouldNavigateToDestinationAndGoBack(){
        // Given
        signUpandSignIn(shouldTypeOnKeyboard: true)
        
        // When
        tapNavigationLink(shouldDismissDestination: true)
        
        // Then
        let navBar = app.navigationBars["Welcome!"]
        XCTAssertTrue(navBar.exists)
    }
    
//    func test_SignedInView_navigationLinkToDestination_shouldNavigateToDestinationAndGoBack2(){
//        // Given
//        //signUpandSignIn(shouldTypeOnKeyboard: true)
//        
//        // When
//        tapNavigationLink(shouldDismissDestination: true)
//        
//        // Then
//        let navBar = app.navigationBars["Welcome!"]
//        XCTAssertTrue(navBar.exists)
//    }
}

// MARK: - Functions

extension ContentView_UITests{
    func signUpandSignIn(shouldTypeOnKeyboard:Bool){
        let textField = app.textFields["SignUpTextField"]
        
        if shouldTypeOnKeyboard{
            textField.tap()
            textField.typeText("Qwerty")
            let returnButton = app.buttons["Return"]
            returnButton.tap()
        }
       
        let signUpButton = app.buttons["SignUpButton"]
        signUpButton.tap()
    }
    
    func tapAlertButton(shouldDismissAlert:Bool){
        let showAlertButton = app.buttons["ShowAlertButton"]
        showAlertButton.tap()
        
        if shouldDismissAlert{
            let alert = app.alerts.firstMatch
            
            let alertOkButton = alert.buttons["OK"]
            
            let alertOkButtonExists = alertOkButton.waitForExistence(timeout: 5)
            XCTAssertTrue(alertOkButtonExists)
            
            alertOkButton.tap()
        }
    }
    
    func tapNavigationLink(shouldDismissDestination:Bool){
        let naviagateButton = app.buttons["navigationLinkToDestination"]
        naviagateButton.tap()
        
        if shouldDismissDestination{
            let backButton = app.navigationBars.buttons["Welcome!"]
            backButton.tap()
        }
    }
    
}

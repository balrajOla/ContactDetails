//
//  iOSContactDetailsUITests.swift
//  iOSContactDetailsUITests
//
//  Created by Balraj Singh on 31/07/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import XCTest

class iOSContactDetailsUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddContactDetails() {
                // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        app.navigationBars["Contacts"].buttons["Add"].tap()
        
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.textFields["Enter First Name"].tap()
        elementsQuery.textFields["Enter First Name"].typeText("abc")
        
        elementsQuery.textFields["Enter Last Name"].tap()
        elementsQuery.textFields["Enter Last Name"].typeText("xyz")
        
        elementsQuery.textFields["Enter Mobile Number"].tap()
        elementsQuery.textFields["Enter Mobile Number"].typeText("9907656600")
        
        elementsQuery.textFields["Enter Email ID"].tap()
        elementsQuery.textFields["Enter Email ID"].typeText("ads@sad.net")
        
        app.navigationBars["Add Details"].buttons["Done"].tap()

        // wait time to let the data save.
        sleep(4)
        
        XCTAssertTrue(app.tables.cells.containing(.staticText, identifier: "abc xyz").staticTexts["abc xyz"].exists)
    }
    
    func testEditContactDetails() {
        let app = XCUIApplication()
        
        app.tables.cells.element(boundBy: 1).tap()
        
        app.navigationBars["Details"].buttons["Edit"].tap()
        
        let elementsQuery = app.scrollViews.otherElements
        
        elementsQuery.textFields["Enter First Name"].tap()
        elementsQuery.textFields["Enter First Name"].clearText(andReplaceWith: "abc")
        
        elementsQuery.textFields["Enter Last Name"].tap()
        elementsQuery.textFields["Enter Last Name"].clearText(andReplaceWith:"xyz")
        
        elementsQuery.textFields["Enter Mobile Number"].tap()
        elementsQuery.textFields["Enter Mobile Number"].clearText(andReplaceWith:"9902786600")
        
        elementsQuery.textFields["Enter Email ID"].tap()
        elementsQuery.textFields["Enter Email ID"].typeText("")
        elementsQuery.textFields["Enter Email ID"].clearText(andReplaceWith:"ads@sad.net")
        
        app.navigationBars["Edit Details"].buttons["Done"].tap()
        
        // wait time to let the data save.
        sleep(4)
        
        XCTAssertTrue(app.scrollViews.otherElements.staticTexts["9902786600"].exists)
    }

}

extension XCUIElement {
    func clearText(andReplaceWith newText:String? = nil) {
        tap()
        tap() //When there is some text, its parts can be selected on the first tap, the second tap clears the selection
        press(forDuration: 1.0)
        let selectAll = XCUIApplication().menuItems["Select All"]
        //For empty fields there will be no "Select All", so we need to check
        if selectAll.waitForExistence(timeout: 0.5), selectAll.exists {
            selectAll.tap()
            typeText(String(XCUIKeyboardKey.delete.rawValue))
        }
        if let newVal = newText { typeText(newVal) }
    }
}

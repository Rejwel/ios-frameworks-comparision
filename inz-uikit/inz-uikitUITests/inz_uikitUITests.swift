//
//  inz_uikitUITests.swift
//  inz-uikitUITests
//
//  Created by Paweł Dera on 06/11/2023.
//

import XCTest

final class inz_uikitUITests: XCTestCase {

    func testMealListViewPerformance() throws {
        let app = XCUIApplication()
        app.launch()
        
        let cell = app.tables.cells.element(boundBy: 0)
        cell.tap()
        
        app.buttons["add-to-favorites-button"].tap()
        
        let animationExpectation = expectation(description: "animation-finished")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            animationExpectation.fulfill()
        }
        wait(for: [animationExpectation], timeout: 1.0)
        
        app.navigationBars.buttons.element(boundBy: 0).tap()
    }
    
    func testMealListViewLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric(), XCTMemoryMetric(), XCTStorageMetric(), XCTCPUMetric()]) {
            try? testMealListViewPerformance()
        }
    }
    
    func testRegistrationViewPerformance() throws {
        let app = XCUIApplication()
        app.launch()
        
        let datePicker = app.datePickers["calendar"]
        datePicker.tap()
        
        datePicker.buttons["Month"].tap()
        
        datePicker.pickerWheels["January"].adjust(toPickerWheelValue: "February")
        datePicker.pickerWheels["2024"].adjust(toPickerWheelValue: "2000")
    
        app.buttons["continue-button"].tap()
        
        let phoneNumberInput = app.textFields["phone-number-input"]
        phoneNumberInput.tap()
        
        phoneNumberInput.typeText("12312312")
        wait(for: [], timeout: 1.0)
        phoneNumberInput.clearAndEnterText(text: "666777888")
        
        app.toolbars.buttons["Done"].tap()
        
        app.buttons["continue-button"].tap()
        
        let firstNameInput = app.textFields["first-name-input"]
        let lastNameInput = app.textFields["last-name-input"]
        let emailNameInput = app.textFields["email-input"]
        let passwordNameInput = app.secureTextFields["password-input"]
        
        firstNameInput.tap()
        firstNameInput.typeText("Adam")
        app.toolbars.buttons["Done"].tap()
        
        lastNameInput.tap()
        lastNameInput.typeText("Nowak")
        app.toolbars.buttons["Done"].tap()
        
        emailNameInput.tap()
        emailNameInput.typeText("adam.nowak@test.com")
        app.toolbars.buttons["Done"].tap()
        
        passwordNameInput.tap()
        passwordNameInput.typeText("test")
        app.toolbars.buttons["Done"].tap()
        
        passwordNameInput.tap()
        wait(for: [], timeout: 1.0)
        passwordNameInput.clearAndEnterText(text: "TestTest123!")
        
        app.toolbars.buttons["Done"].tap()
        
        app.buttons["continue-button"].tap()
        
        wait(for: [], timeout: 3.0)
    }
    
    func testRegistrationViewLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric(), XCTMemoryMetric(), XCTStorageMetric(), XCTCPUMetric()]) {
          try? testRegistrationViewPerformance()
        }
    }
    
    func testPhotoViewPerformance() throws {
        let app = XCUIApplication()
        app.launch()
        
        let collectionView = app.collectionViews["collection-view"]
        
        let cell = collectionView.cells.element(boundBy: 0)
        cell.tap()
        
        let photo = app.images["photo"]
        photo.pinch(withScale: 0.9, velocity: -2.0)
        photo.pinch(withScale: 0.8, velocity: -2.0)
        photo.pinch(withScale: 0.7, velocity: -2.0)
        
        app.buttons["process-image-button"].tap()
        app.buttons["process-image-button"].tap()
        app.buttons["process-image-button"].tap()
        app.buttons["process-image-button"].tap()
        
        photo.pinch(withScale: 1.1, velocity: 2.0)
        photo.pinch(withScale: 1.2, velocity: 2.0)
        photo.pinch(withScale: 1.3, velocity: 2.0)
        
        app.buttons["close-button"].tap()
        
        collectionView.swipeUp()
        
        let cell2 = collectionView.cells.element(boundBy: collectionView.cells.count - 1)
        cell2.tap()
        
        let photo2 = app.images["photo"]
        photo2.pinch(withScale: 0.9, velocity: -2.0)
        photo2.pinch(withScale: 0.8, velocity: -2.0)
        photo2.pinch(withScale: 0.7, velocity: -2.0)
        
        app.buttons["process-image-button"].tap()
        app.buttons["process-image-button"].tap()
        app.buttons["process-image-button"].tap()
        app.buttons["process-image-button"].tap()
        
        photo2.pinch(withScale: 1.1, velocity: 2.0)
        photo2.pinch(withScale: 1.2, velocity: 2.0)
        photo2.pinch(withScale: 1.3, velocity: 2.0)
        
        app.buttons["close-button"].tap()
    }
    
    func testPhotoViewLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric(), XCTMemoryMetric(), XCTStorageMetric(), XCTCPUMetric()]) {
            try? testPhotoViewPerformance()
        }
    }
    
}

extension XCUIElement {
    func clearAndEnterText(text: String) {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }
        
        self.tap()
        
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        
        self.typeText(deleteString)
        self.typeText(text)
    }
}

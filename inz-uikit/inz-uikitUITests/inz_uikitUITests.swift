//
//  inz_uikitUITests.swift
//  inz-uikitUITests
//
//  Created by Paweł Dera on 06/11/2023.
//

import XCTest

final class inz_uikitUITests: XCTestCase {

    func testPerformance() throws {
        let app = XCUIApplication()
        app.launch()
        let cell = app.tables.cells.element(boundBy: app.tables.cells.count - 1)
        cell.tap()
        
        app.buttons["add-to-favorites-button"].tap()
        
        
        let animationExpectation = expectation(description: "animation-finished")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            animationExpectation.fulfill()
        }
        wait(for: [animationExpectation], timeout: 1.0)
        
        app.navigationBars.buttons.element(boundBy: 0).tap()
    }
    
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric(), XCTMemoryMetric(), XCTStorageMetric(), XCTCPUMetric()]) {
            let app = XCUIApplication()
            app.launch()
            let cell = app.tables.cells.element(boundBy: app.tables.cells.count - 1)
            cell.tap()
            
            app.buttons["add-to-favorites-button"].tap()
            
            
            let animationExpectation = expectation(description: "animation-finished")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                animationExpectation.fulfill()
            }
            wait(for: [animationExpectation], timeout: 1.0)
            
            app.navigationBars.buttons.element(boundBy: 0).tap()
        }
    }
}

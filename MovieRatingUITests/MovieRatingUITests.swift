//
//  MovieRatingUITests.swift
//  MovieRatingUITests
//
//  Created by cagatay_personal on 11.05.19.
//  Copyright © 2019 cagatay. All rights reserved.
//

import XCTest

class MovieRatingUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        
        if app.state != .runningForeground { // no need to restart app for every test
            app.launch()
        }
    }

    override func tearDown() {
        super.tearDown()
    }

    func testIfRateButtonShowsAllRatings() {
        app.tables.cells.firstMatch.buttons["Rate"].tap()
        
        XCTAssert(app.sheets.buttons["Not rated"].exists, "Rating options do not show Not rated")
        XCTAssert(app.sheets.buttons["1 Star"].exists, "Rating options do not show 1 Star")
        XCTAssert(app.sheets.buttons["2 Star"].exists, "Rating options do not show 2 star")
        XCTAssert(app.sheets.buttons["3 Star"].exists, "Rating options do not show 3 star")
        XCTAssert(app.sheets.buttons["4 Star"].exists, "Rating options do not show 4 star")
        XCTAssert(app.sheets.buttons["5 Star"].exists, "Rating options do not show 5 star")
        XCTAssert(app.sheets.buttons["Cancel"].exists, "Rating options do not show Cancel")
        
        app.sheets.buttons["Cancel"].tap()
    }
    
    func testRatingSingleMovie() {
        let firstCell = app.tables.cells.firstMatch
        let firstCellTitle = firstCell.staticTexts.allElementsBoundByIndex[firstCell.staticTexts.count - 1].label
        
        firstCell.buttons["Rate"].tap()
        XCTAssert(app.sheets.buttons["1 Star"].exists, "Alert dialog that includes ratings is not shown")
        app.sheets.buttons["1 Star"].tap()
        
        XCTAssert(app.tables.cells.containing(.staticText, identifier: firstCellTitle).staticTexts["Rated: 1 Star"].exists,
                  "Rating a movie item did not show it on the list")
    }
    
    func testIfRatingReordersList() {
        let secondCell = app.tables.cells.allElementsBoundByIndex[1]
        let secondCellTitle = secondCell.staticTexts.allElementsBoundByIndex[1].label
        
        secondCell.buttons["Rate"].tap()
        XCTAssert(app.sheets.buttons["5 Star"].exists, "Alert dialog that includes ratings is not shown")
        app.sheets.buttons["5 Star"].tap()
        
        XCTAssert(app.tables.cells.firstMatch.staticTexts[secondCellTitle].exists,
                  "5 Stared item did not move up to first item of the list")
        
    }
}

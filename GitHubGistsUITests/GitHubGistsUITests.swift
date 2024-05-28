//
//  GitHubGistsUITests.swift
//  GitHubGistsUITests
//
//  Created by Mauricio Lorenzetti on 27/05/24.
//

import XCTest

final class GitHubGistsUITests: XCTestCase {
        
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    func testGistListDisplay() throws {
        // Wait for table view to appear
        let tableView = app.tables["gistTableView"]
        XCTAssertTrue(tableView.exists)
        
        // Testing if there is at least one cell
        let firstCell = tableView.cells.element(matching: .cell, identifier: "gistCell_0")
        XCTAssertTrue(firstCell.exists)

        // Testing cell has labels
        let loginLabel = firstCell.staticTexts["loginLabel"]
        XCTAssertTrue(loginLabel.exists)

        let filesCountLabel = firstCell.staticTexts["filesCountLabel"]
        XCTAssertTrue(filesCountLabel.exists)
        
        // Tap on the first cell to navigate to details screen
        firstCell.tap()
        
        // Testing if appropriate navigation transition happens
        let gistDetailsNavigationBar = app.navigationBars["gistDetails"]
        XCTAssertTrue(gistDetailsNavigationBar.exists)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

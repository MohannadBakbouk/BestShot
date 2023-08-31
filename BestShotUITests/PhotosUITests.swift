//
//  PhotosUITests.swift
//  BestShotUITests
//
//  Created by Mohannad on 30/08/2023.
//

import XCTest

private let collectionIdentifier = "PhotosCollection"
private let tableIdentifier = "HistoryTermsTable"

final class PhotosUITests: XCTestCase {
    var app = XCUIApplication()
    
    override func setUpWithError() throws {
        app.launchArguments = ["-uitesting"]
        app.launch()
    }

    override func tearDownWithError() throws {
        app.terminate()
    }

    func testIsNavigationBarHidden() throws {
       XCTAssert(app.navigationBars.count == 0)
    }
    
    func testIsSearchBarShown() throws{
        XCTAssert(app.searchFields["Search"].waitForExistence(timeout: 5))
    }
    
    func testArePhotosShown() throws{
        let collection = app.collectionViews[collectionIdentifier]
        XCTAssert(collection.waitForExistence(timeout: 5))
        XCTAssert(collection.cells.count > 0)
    }
    
    func testIsLazyLoadingWorking() throws{
        let collection = app.collectionViews[collectionIdentifier]
        var cellsCount: Set<Int> = []
        _ = collection.waitForExistence(timeout: 7)
        let cells = app.collectionViews[collectionIdentifier].cells
        /* The idea is cells are only the displayed ones so when the user is scrolling their count is going to change which means the app has fetched a new batch of photos */
        (0...4).forEach{_ in
            collection.swipeUp()
            cellsCount.insert(cells.count)
        }
        XCTAssert(cellsCount.count > 1, "The lazy loading is not working")
    }
    
    func testIsKeyboardShownAtSearching() throws{
        _ = XCTWaiter.wait(for: [expectation(description: "Waiting for the app gets home screen")], timeout: 5)
        app.searchFields["Search"].tap()
        XCTAssert(app.keyboards.count > 0 , "The keyboard is not shown")
    }
    
    func testAreHistorySearchShown() throws{
        let searchBar = app.searchFields["Search"]
        _ = searchBar.waitForExistence(timeout: 5)
        searchBar.tap()
        XCTAssert(app.tables[tableIdentifier].waitForExistence(timeout: 2))
        XCTAssert(app.tables[tableIdentifier].cells.count > 0)
    }
    
    func testSelectHistorySearchItem() throws{
        let searchBar = app.searchFields["Search"]
        _ = searchBar.waitForExistence(timeout: 5)
        searchBar.tap()
        let searchedTermsTable = app.tables[tableIdentifier]
        let cell = searchedTermsTable.children(matching: .cell).element(boundBy: 0)
        let selectedTerm = cell.children(matching: .staticText).firstMatch.label
        cell.tap()
        XCTAssert((searchBar.value as? String) == selectedTerm, "Selecting a history search item didn't work")
    }
    
    func testIsSearchFetchingResults() throws{
        /*Here also I'm going to depend on the cell's count so when the user types a term to search for it will get equal to zero and as soon as the search has been performed it going to have a value more than zero */
        let searchBar = app.searchFields["Search"]
        let collection = app.collectionViews[collectionIdentifier]
        _ = searchBar.waitForExistence(timeout: 5)
        searchBar.tap()
        searchBar.typeText("Saudi Arabia")
        app.buttons["Search"].tap()
        XCTAssert(collection.cells.count == 0 , "The app didn't clear old items")
        _ = XCTWaiter.wait(for: [expectation(description: "Waiting for the app search action")], timeout: 5)
        XCTAssert(collection.cells.count > 0 , "the searching functionality is not working")
    }
    
    func testTapSearchButtonHideKeyboard() throws{
        let searchBar = app.searchFields["Search"]
        _ = searchBar.waitForExistence(timeout: 5)
        searchBar.tap()
        XCTAssert(app.keyboards.count > 0 , "The keyboard is not shown")
        searchBar.typeText("United Arab Emirates")
        app.buttons["Search"].tap()
        XCTAssert(app.keyboards.count == 0 , "The keyboard is not hidden")
    }
    
    func testTapCancelButtonHideKeyboard() throws{
        let searchBar = app.searchFields["Search"]
        _ = searchBar.waitForExistence(timeout: 5)
        searchBar.tap()
        XCTAssert(app.keyboards.count > 0 , "The keyboard is not shown")
        app.buttons["Cancel"].tap()
        XCTAssert(app.keyboards.count == 0 , "The keyboard is not hidden")
    }
}

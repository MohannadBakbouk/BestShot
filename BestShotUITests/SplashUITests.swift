//
//  SplashUITests.swift
//  BestShotUITests
//
//  Created by Mohannad on 30/08/2023.
//

import XCTest

final class SplashUITests: XCTestCase {
    var app = XCUIApplication()
    
    override func setUpWithError() throws {
        app.launchArguments = ["-uitesting"]
    }

    override func tearDownWithError() throws {
        app.terminate()
    }

    func testIsIndicatorShown() throws {
        app.launch()
        XCTAssert(app.activityIndicators["InidicatorView"].exists)
    }
    
    func testIsSlugShown() throws{
        app.launch()
        XCTAssert(app.staticTexts["SlugLabel"].exists)
    }
}

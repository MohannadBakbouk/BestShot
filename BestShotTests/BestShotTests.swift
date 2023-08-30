//
//  BestShotTests.swift
//  BestShotTests
//
//  Created by Mohannad on 29/08/2023.
//

import XCTest
@testable import BestShot

final class BestShotTests: XCTestCase {

    override func setUpWithError() throws {
        MockedPhotoService().fetchImage(url: URL(string: ApiInfo.baseUrl)!)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
      XCTAssert(1 == 1)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

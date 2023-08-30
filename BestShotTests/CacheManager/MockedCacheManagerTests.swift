//
//  MockedCacheManagerTests.swift
//  BestShotTests
//
//  Created by Mohannad on 30/08/2023.
//

import XCTest
@testable import BestShot

final class MockedCacheManagerTests: XCTestCase {
    var cacheManager: CacheManagerProtocol!
    var queries: [QueryObject]!
    override func setUpWithError() throws {
        cacheManager =  MockedCasheManager()
        queries = [QueryObject(text: "Germany"),
                   QueryObject(text: "Netherlands"),
                   QueryObject(text: "Austria")]
    }

    override func tearDownWithError() throws {
        cacheManager = nil
        queries.removeAll()
    }

    func testAddQuery() throws {
        cacheManager.add(info: queries.first!, entity: Query.self)
        let items = cacheManager.fetchAll(entity: Query.self)
        XCTAssert((items?.count ?? 0) > 0 , "Failed to add Query")
    }

    func testFetchQueries(){
        _ = queries.map{cacheManager.add(info:$0, entity: Query.self)}
        let items = cacheManager.fetchAll(entity: Query.self)
        XCTAssert((items?.count ?? 0) == queries.count , "Failed to fetch Queries")
    }

    func testDeleteQuery() throws {
        cacheManager.add(info: queries.first!, entity: Query.self)
        let addedItem =  cacheManager.fetchAll(entity: Query.self)?.first
        cacheManager.delete(entity: addedItem!)
        let count =  cacheManager.recordsCount(entity: Query.self)
        XCTAssert(count == 0, "Failed to delete query")
    }

    func testDeleteAllQueries() throws {
        _ = queries.map{cacheManager.add(info:$0, entity: Query.self)}
        let count =  cacheManager.recordsCount(entity: Query.self)
        XCTAssert(count == queries.count, "Failed to add new queries")
        cacheManager.deleteAll(entity: Query.self)
        let newCount =  cacheManager.recordsCount(entity: Query.self)
        XCTAssert(newCount == 0, "Failed to delete all queries")
    }

    func testCountQueries(){
        _ = queries.map{cacheManager.add(info:$0, entity: Query.self)}
        let count = cacheManager.recordsCount(entity: Query.self)
        XCTAssert(count == queries.count , "Failed to fetch Queries's count")
    }
}

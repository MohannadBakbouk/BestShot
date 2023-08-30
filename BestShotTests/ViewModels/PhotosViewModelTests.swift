//
//  PhotosViewModelTests.swift
//  BestShotTests
//
//  Created by Mohannad on 30/08/2023.
//

import XCTest
import RxTest
import RxSwift
@testable import BestShot

final class PhotosViewModelTests: XCTestCase {
    
    var viewModel : PhotosViewModelProtocol!
    var disposeBag : DisposeBag!
    var scheduler : TestScheduler!
    var cacheManager: CacheManagerProtocol!
    var queries: [QueryObject]! = []

    override func setUpWithError() throws {
        scheduler = TestScheduler(initialClock: 0)
        cacheManager = MockedCasheManager()
        viewModel = PhotosViewModel(service: MockedPhotoService(), cacheManager: cacheManager)
        disposeBag = DisposeBag()
        ["Germany","Netherlands","Austria"].forEach{
            let query = QueryObject(text: $0)
            queries.append(query)
            cacheManager.add(info: query, entity: Query.self)
        }
    }

    override func tearDownWithError() throws {
        scheduler = nil
        viewModel = nil
        cacheManager = nil
        disposeBag = nil
        queries.removeAll()
    }
    
    func testIsLoadingIndicatorPublished(){
         let isLoading = scheduler.createObserver(Bool.self)
         viewModel.isLoading
        .bind(to: isLoading)
        .disposed(by: disposeBag)
        
         viewModel.searchPhotos() // trigger
        _ = XCTWaiter.wait(for: [expectation(description: "it waits for some time")], timeout: 3)
         XCTAssertRecordedElements(isLoading.events, [true, false])
    }
    
    func testArePhotosPublished(){
        let photos = scheduler.createObserver([PhotoViewData].self)
        viewModel.photos
        .bind(to: photos)
        .disposed(by: disposeBag)
        viewModel.searchPhotos()
        _ = XCTWaiter.wait(for: [expectation(description: "wait to process the fetched photos")], timeout: 3)
        let items = photos.events.last?.value.element
        XCTAssert((items?.count ?? 0) > 0, "Photots are not publishing items")
    }
    
    func testIsErrorPublished(){
        let error = scheduler.createObserver(ErrorDataView?.self)
        let expectedMessage = NetworkError.internetOffline.message
         viewModel.error
        .bind(to: error)
        .disposed(by: disposeBag)
        
         viewModel.error.onNext(ErrorDataView(with: .internetOffline)) // trigger
         guard let value = error.events.last?.value.element else {
            XCTFail("Error is not publishing the message")
            return
         }
        XCTAssert(value?.message == expectedMessage, "Error is not publishing the message")
    }
    
    func testIsLazyLoadingWorking(){
        let photos = scheduler.createObserver([PhotoViewData].self)
        viewModel.photos
        .bind(to: photos)
        .disposed(by: disposeBag)
        viewModel.searchPhotos()
        _ = XCTWaiter.wait(for: [expectation(description:"")], timeout: 3)
        
        viewModel.reachedBottomTrigger.onNext(Void()) // trigger
        _ = XCTWaiter.wait(for: [expectation(description:"")], timeout: 3)
        let items = photos.events.last?.value.element
        XCTAssert((items?.count ?? 0) == 50, "Lazy Loading is not working")
        XCTAssert(viewModel.searchParams.page == 2)
    }
    
    func testAreHistorySearchItemsPublished(){
        let cachedQueries = scheduler.createObserver([String].self)
        viewModel.historySearchItems
       .bind(to: cachedQueries)
       .disposed(by: disposeBag)
        
        viewModel.loadHistorySearchTrigger.onNext(()) // trigger
        
        let items = cachedQueries.events.last?.value.element
        XCTAssert((items?.count ?? 0) == queries.count , "History Search Items are not published")
    }
    
    func testIsSearchTriggerWorking(){
        let photos = scheduler.createObserver([PhotoViewData].self)
        let query = "Saudi Arabia"
        
        viewModel.photos
        .bind(to: photos)
        .disposed(by: disposeBag)
        
        viewModel.searchQuery.onNext(query)
        XCTAssert(viewModel.searchParams.query == query)
        
        _ = XCTWaiter.wait(for:[expectation(description: "wait to process the fetched photos")], timeout: 3)
        let items = photos.events.last?.value.element
        XCTAssert((items?.count ?? 0) > 0, "Photots are not publishing items")
    }
    
    func testIsCachingOfSearchTermsDone(){
        let query = "Saudi Arabia"
        viewModel.searchQuery.onNext(query)
        var queries = cacheManager.fetchAll(entity: Query.self)
        queries?.sort(by: {$0.date! > $1.date!})
        XCTAssert(queries?.first?.text == query)
    }
}

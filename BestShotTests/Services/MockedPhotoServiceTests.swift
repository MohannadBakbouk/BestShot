//
//  MockedPhotoServiceTests.swift
//  BestShotTests
//
//  Created by Mohannad on 30/08/2023.
//

import XCTest
import RxTest
import RxSwift
import RxCocoa
@testable import BestShot

final class MockedPhotoServiceTests: XCTestCase {

    var photoService: PhotoServiceProtocol!
    var disposeBag : DisposeBag!
    var scheduler : TestScheduler!

    override func setUpWithError() throws {
        photoService = MockedPhotoService()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        photoService = nil
        scheduler = nil
        disposeBag = nil
    }
    
    func testSearchPhotos() throws {
        let photosResponse = scheduler.createObserver(SearchPhotosResponse.self)
         photoService.searchPhotos(params: SearchParams())
        .bind(to: photosResponse)
        .disposed(by: disposeBag)
         XCTAssert((photosResponse.events.first?.value.element?.results?.items.count  ?? 0) > 0 , "Failed to load items from the json file")
    }
    
    func testFetchImage() throws {
        let image = scheduler.createObserver(Data.self)
        photoService.fetchImage(url: ApiInfo.baseUrl.asURL()!)
        .bind(to: image)
       .disposed(by: disposeBag)
        XCTAssert((image.events.first?.value.element?.count ?? 0) > 0 , "Failed to load image from the local resources")
    }
    
    func testRequestReturnError() throws {
        let expectations = expectation(description: "the request retrun not found error")
        var error: Error?
         photoService.searchPhotos(params: SearchParams(page: 5))
        .subscribe(onError: {emittedError in
            error = emittedError
            expectations.fulfill()
        }).disposed(by: disposeBag)
        
        wait(for: [expectations], timeout: 5)
        XCTAssert((error as? NetworkError) == NetworkError.notFound , "return not found error")
    }

}

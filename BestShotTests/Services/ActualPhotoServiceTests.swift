//
//  ActualPhotoServiceTests.swift
//  BestShotTests
//
//  Created by Mohannad on 30/08/2023.
//

import XCTest
import RxTest
import RxSwift
import RxCocoa
@testable import BestShot

final class ActualPhotoServiceTests: XCTestCase {
    var photoService: PhotoServiceProtocol!
    var disposeBag : DisposeBag!

    override func setUpWithError() throws {
        photoService = PhotoService()
        disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        photoService = nil
        disposeBag = nil
    }
    
    func testSearchPhotos() throws {
        let expectations = expectation(description: "executing search photos api action")
        var photos: [Photo] = []
         photoService.searchPhotos(params: SearchParams(query: "Netherlands"))
         .subscribe(onNext: {event in
             guard let items = event.results?.items else {return}
             photos.append(contentsOf: items)
             expectations.fulfill()
         }).disposed(by: disposeBag)
        
        wait(for: [expectations], timeout: 5)
        XCTAssert(photos.count > 10 , "Failed to search photos from api")
    }
    
    func testFetchImage() throws {
        let expectations = expectation(description: "executing fetch image api action")
        let url = "https://farm66.static.flickr.com/65535/53150933327_2452b6ddb1.jpg".asURL()!
        var image: Data?
        photoService.fetchImage(url: url)
        .subscribe(onNext:{ item in
            image = item
            expectations.fulfill()
        }).disposed(by: disposeBag)
        
        wait(for: [expectations], timeout: 5)
        XCTAssert((image?.count ?? 0) > 0 , "Failed to fetch image from api")
    }
    
    func testRequestReturnError() throws {
        let expectations = expectation(description: "executing fetch image api action with error")
        let dummryUrl = "https://farm66.flickr.com/6.jpg".asURL()!
        var error: Error?
        photoService.fetchImage(url: dummryUrl)
        .subscribe(onError: {emittedError in
            error = emittedError
            expectations.fulfill()
        }).disposed(by: disposeBag)
        
        wait(for: [expectations], timeout: 5)
        XCTAssert((error as? NetworkError) == NetworkError.invalidHostname , "return host is invalid error")
    }
}

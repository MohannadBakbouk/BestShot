//
//  MockedPhotoService.swift
//  BestShotTests
//
//  Created by Mohannad on 30/08/2023.
//

import Foundation
import RxSwift
@testable import BestShot

final class MockedPhotoService: PhotoServiceProtocol{
    func searchPhotos(params: SearchParams) -> Observable<SearchPhotosResponse> {
        let bundle = Bundle(for: MockedPhotoService.self)
        let resourceName = "PhotosPage\(params.page)"
        guard let url = bundle.url(forResource: resourceName, withExtension: "json"),
              let data =  try? Data(contentsOf: url),
              let response = try? JSONDecoder().decode(SearchPhotosResponse.self, from: data) else {
          return Observable.error(NetworkError.notFound)
        }
        return Observable.just(response)
    }
    
    func fetchImage(url: URL) -> Observable<Data> {
        let bundle = Bundle(for: MockedPhotoService.self)
        let id = Int.random(in: 1...5)
        guard let url = bundle.url(forResource: "Image\(id)", withExtension: "jpg"),
              let data =  try? Data(contentsOf: url) else {
            return Observable.error(NetworkError.notFound)
        }
        return Observable.just(data)
    }
}

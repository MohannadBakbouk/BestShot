//
//  PhotoService.swift
//  BestShot
//
//  Created by Mohannad on 29/08/2023.
//

import Foundation
import RxSwift

protocol PhotoServiceProtocol {
    func searchPhotos(params: SearchParams) -> Observable<SearchPhotosResponse>
    func fetchImage(url : URL) -> Observable<Data>
}

final class PhotoService: PhotoServiceProtocol{
    let networkManager : NetworkManagerProtocol
    
    init (networkManager : NetworkManagerProtocol = NetworkManager()){
        self.networkManager = networkManager
    }
    
    func searchPhotos(params: SearchParams) -> Observable<SearchPhotosResponse> {
        return networkManager.request(endpoint: PhotosEndpoint.searchPhotos(info: params), method: .Get)
    }
    
    func fetchImage(url: URL) -> Observable<Data> {
        return networkManager.request(endpoint: PhotosEndpoint.fetchImage(url: url), method: .Get)
    }
}

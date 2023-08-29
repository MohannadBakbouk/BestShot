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
}

final class PhotoService: PhotoServiceProtocol{
    let networkManager : NetworkManagerProtocol
    
    init (networkManager : NetworkManagerProtocol = NetworkManager()){
        self.networkManager = networkManager
    }
    
    func searchPhotos(params: SearchParams) -> Observable<SearchPhotosResponse> {
        return networkManager.request(endpoint: PhotosEndpoint.searchPhotos(info: params), method: .Get)
    }
}

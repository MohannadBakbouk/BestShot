//
//  PhotosViewModelProtocol.swift
//  BestShot
//
//  Created by Mohannad on 29/08/2023.
//

import RxCocoa

protocol PhotosViewModelProtocol: BaseViewModelProtocol{
    var photos: BehaviorRelay<[PhotoViewData]>{get}
    var fetchedPhotos: BehaviorRelay<[Photo]>{get}
    func searchPhotos()
}

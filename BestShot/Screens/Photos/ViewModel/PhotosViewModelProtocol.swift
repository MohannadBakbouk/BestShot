//
//  PhotosViewModelProtocol.swift
//  BestShot
//
//  Created by Mohannad on 29/08/2023.
//

import RxSwift
import RxCocoa

protocol PhotosViewModelProtocol: BaseViewModelProtocol{
    var photos: BehaviorRelay<[PhotoViewData]>{get}
    var historySearchItems: BehaviorRelay<[String]>{get}
    var fetchedPhotos: BehaviorRelay<[Photo]>{get}
    var searchQuery: PublishSubject<String?>{get}
    var reachedBottomTrigger: PublishSubject<Void>{get}
    var loadHistorySearchTrigger: PublishSubject<Void>{get}
    var isLoadingMore: BehaviorRelay<Bool>{get}
    func searchPhotos()
}

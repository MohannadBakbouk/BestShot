//
//  PhotosViewModel.swift
//  BestShot
//
//  Created by Mohannad on 29/08/2023.
//

import RxSwift
import RxCocoa

final class PhotosViewModel: PhotosViewModelProtocol{
    private let service: PhotoServiceProtocol
    private var searchParams : SearchParams
    //Output events
    var isLoading: PublishSubject<Bool>
    var error: BehaviorSubject<ErrorDataView?>
    var photos: BehaviorRelay<[PhotoViewData]>
    let disposeBag: DisposeBag
    
    init(service: PhotoServiceProtocol) {
        self.service = service
        self.searchParams = SearchParams(query: "Germany")
        self.disposeBag = DisposeBag()
        self.isLoading = PublishSubject()
        self.error = BehaviorSubject(value: nil)
        self.photos = BehaviorRelay(value: [])
    }

    func searchPhotos(){
        service.searchPhotos(params: searchParams)
        .subscribe(onNext: {[weak self] event in
            guard let items = event.results?.items else {return}
            self?.photos.accept(items.map{PhotoViewData(info: $0)})
        }, onError : {[weak self] error in

        }).disposed(by: disposeBag)
    }
    
}

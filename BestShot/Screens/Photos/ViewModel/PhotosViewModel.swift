//
//  PhotosViewModel.swift
//  BestShot
//
//  Created by Mohannad on 29/08/2023.
//
import Foundation
import RxSwift
import RxCocoa

final class PhotosViewModel: PhotosViewModelProtocol{
    private let service: PhotoServiceProtocol
    private var searchParams : SearchParams
    //Output events
    var isLoading: PublishSubject<Bool>
    var error: BehaviorSubject<ErrorDataView?>
    var photos: BehaviorRelay<[PhotoViewData]>
    var fetchedPhotos: BehaviorRelay<[Photo]>
    let disposeBag: DisposeBag
    
    init(service: PhotoServiceProtocol) {
        self.service = service
        self.searchParams = SearchParams(query: "Netherlands")
        self.disposeBag = DisposeBag()
        self.isLoading = PublishSubject()
        self.error = BehaviorSubject(value: nil)
        self.photos = BehaviorRelay(value: [])
        self.fetchedPhotos = BehaviorRelay(value: [])
        subscribingToFetchedPhotos()
        
    }

    func searchPhotos(){
        service.searchPhotos(params: searchParams)
        .subscribe(onNext: {[weak self] event in
            guard let items = event.results?.items else {return}
            self?.fetchedPhotos.accept(items)
            self?.searchParams.pages = event.results?.pages ?? 0
        }, onError : {[weak self] error in
           print(error)
        }).disposed(by: disposeBag)
    }
    
    private func processFetchedPhotos(){
        let group =  DispatchGroup()
        let semaphore = DispatchSemaphore(value: 5)
        for item in fetchedPhotos.value {
            guard let _ = item.url?.asURL() else {continue}
            loadImage(for: item, group, semaphore)
        }
        
        group.notify(queue: DispatchQueue.main){[weak self] in
            guard let self = self else {return}
            let newItems = self.fetchedPhotos.value
            self.photos.accept(self.photos.value + newItems.map{PhotoViewData(info: $0)})
        }
    }
    
    private func loadImage(for item: Photo,_ downloadGroup: DispatchGroup ,_ semaphore: DispatchSemaphore){
        guard let url = item.url?.asURL() else {return}
        downloadGroup.enter()
        DispatchQueue.global(qos: .background).async{[weak self] in
            guard let self = self else {return}
            semaphore.wait()
            self.service.fetchImage(url: url)
            .subscribe(onNext: {data in
                item.image = UIImage(data: data)
                semaphore.signal()
                downloadGroup.leave()
            }, onError: { _ in
                semaphore.signal()
                downloadGroup.leave()
            }).disposed(by: self.disposeBag)
        }
    }
    
    private func subscribingToFetchedPhotos(){
        fetchedPhotos
        .filter{$0.count > 0}
        .subscribe(onNext:{[weak self]_ in
            self?.processFetchedPhotos()
        }).disposed(by: disposeBag)
    }
}


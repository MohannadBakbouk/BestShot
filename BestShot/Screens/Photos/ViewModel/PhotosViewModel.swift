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
    private let cacheManager: CacheManagerProtocol
    private var searchParams : SearchParams
    //Output events
    var isLoading: PublishSubject<Bool>
    var error: BehaviorSubject<ErrorDataView?>
    var photos: BehaviorRelay<[PhotoViewData]>
    var historySearchItems: BehaviorRelay<[String]>
    //Inputs events
    var searchQuery: PublishSubject<String?>
    var reachedBottomTrigger: PublishSubject<Void>
    var loadHistorySearchTrigger: PublishSubject<Void>
    //Internal events
    var fetchedPhotos: BehaviorRelay<[Photo]>
    var isLoadingMore: BehaviorRelay<Bool>
    let disposeBag: DisposeBag
    
    init(service: PhotoServiceProtocol, cacheManager: CacheManagerProtocol) {
        self.service = service
        self.cacheManager = cacheManager
        self.searchParams = SearchParams(query: "Netherlands")
        self.disposeBag = DisposeBag()
        self.isLoading = PublishSubject()
        self.error = BehaviorSubject(value: nil)
        self.photos = BehaviorRelay(value: [])
        self.historySearchItems = BehaviorRelay(value: [])
        self.fetchedPhotos = BehaviorRelay(value: [])
        self.searchQuery = PublishSubject()
        self.reachedBottomTrigger = PublishSubject()
        self.loadHistorySearchTrigger = PublishSubject()
        self.isLoadingMore = BehaviorRelay(value: false)
        self.cacheManager.setup(completion: nil)
        subscribingToFetchedPhotos()
        subscribingToSearchQuery()
        subscribingToReachedBottomTrigger()
        subscribingToHistorySearchTrigger()
    }

    func searchPhotos(){
        isLoading.onNext(true)
        service.searchPhotos(params: searchParams)
        .subscribe(onNext: {[weak self] event in
            guard let items = event.results?.items else {return}
            self?.fetchedPhotos.accept(items)
            self?.searchParams.pages = event.results?.pages ?? 0
        }, onError : {[weak self] error in
            let networkError = error as? NetworkError ?? .errorOccured
            self?.isLoadingMore.accept(false)
            self?.isLoading.onNext(false)
            self?.error.onNext(ErrorDataView(with: networkError))
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
            let newItems = self.fetchedPhotos.value.map{PhotoViewData(info: $0)}
            let emittedItems = self.searchParams.page > 1 ? (self.photos.value + newItems) : newItems
            self.isLoading.onNext(false)
            self.photos.accept(emittedItems)
            self.isLoadingMore.accept(false)
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
    
    private func subscribingToSearchQuery(){
        searchQuery
        .compactMap{$0}
        .subscribe(onNext:{[weak self] text in
            self?.searchParams = SearchParams(query: text)
            self?.photos.accept([])
            self?.searchPhotos()
            self?.cacheManager.add(info: QueryObject(text: text), entity: Query.self)
        }).disposed(by: disposeBag)
    }
    
    private func subscribingToReachedBottomTrigger(){
         reachedBottomTrigger
        .filter{[weak self] in
            self?.searchParams.canLoadMore ?? false
         }
        .withLatestFrom(isLoadingMore)
        .filter{!$0}
        .subscribe(onNext:{[weak self]_ in
            self?.isLoadingMore.accept(true)
            self?.searchParams.page += 1
            self?.searchPhotos()
        }).disposed(by: disposeBag)
    }
    
    private func subscribingToHistorySearchTrigger(){
        loadHistorySearchTrigger
        .subscribe(onNext:{[weak self]_ in
            guard let items = self?.cacheManager.fetchAll(entity: Query.self) else {return}
            self?.historySearchItems.accept(items.compactMap{$0.text})
        }).disposed(by: disposeBag)
    }
}


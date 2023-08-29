//
//  PhotosViewModel.swift
//  BestShot
//
//  Created by Mohannad on 29/08/2023.
//

import RxSwift
import RxCocoa

final class PhotosViewModel: PhotosViewModelProtocol{
    
    //Output events
    var isLoading: PublishSubject<Bool>
    var error: BehaviorSubject<ErrorDataView?>
    let disposeBag: DisposeBag
    
    init() {
        self.disposeBag = DisposeBag()
        self.isLoading = PublishSubject()
        self.error = BehaviorSubject(value: nil)
    }
    
}

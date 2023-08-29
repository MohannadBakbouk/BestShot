//
//  UIPhotosController.swift
//  BestShot
//
//  Created by Mohannad on 29/08/2023.
//

import UIKit

final class UIPhotosController: UIBaseViewController<PhotosViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        
        PhotoService().searchPhotos(params: SearchParams(query: "Dubia"))
        .subscribe(onNext: {[weak self] event in
            print(event.results?.items.count, "items's count")
        }, onError : {[weak self] error in
           print(error)
        }).disposed(by: disposeBag)
    }
}

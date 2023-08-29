//
//  UIPhotosController.swift
//  BestShot
//
//  Created by Mohannad on 29/08/2023.
//

import UIKit
import RxSwift
import RxCocoa

final class UIPhotosController: UIBaseViewController<PhotosViewModel> {
    
    private let padding: CGFloat = 10.0
    
    private lazy var collectionView : UICollectionView = {
        let collection = UICollectionView(frame: .zero , collectionViewLayout: collectionViewLayout)
        collection.allowsMultipleSelection = false
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.accessibilityIdentifier = "PhotosCollection"
        return collection
    }()
    
    private lazy var collectionViewLayout : UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.minimumLineSpacing = padding
        layout.minimumInteritemSpacing = padding
        return layout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        viewModel.searchPhotos()
        bindingCollectionViewDataSource()
    }
    
    private func setupViews(){
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.register(UIPhotoCell.self)
        setupConstraints()
    }
    
    private func setupConstraints(){
        collectionView.snp.makeConstraints{ maker in
            maker.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            maker.leading.equalToSuperview().offset(10)
            maker.bottom.trailing.equalToSuperview().offset(-10)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        _ = collectionView.frame == .zero ? collectionView.layoutIfNeeded() : ()
        setupCollectionCellSize()
    }

    private func setupCollectionCellSize(){
        let sectionInset = collectionViewLayout.sectionInset
        let width = (collectionView.frame.width ) - (sectionInset.left + sectionInset.right)
        let height = (collectionView.frame.height) - (sectionInset.top + sectionInset.bottom)
        collectionViewLayout.itemSize = CGSize(width: (width - padding) / 2 , height: (height - padding) / 2.5)
    }
    
    func bindingCollectionViewDataSource(){
        viewModel.photos
        .bind(to: collectionView.rx.items){(collection, index , model) in
            let target = IndexPath(row: index, section: 0)
            let cell = collection.dequeueReusableCell(with: UIPhotoCell.self, for: target)  as? UIPhotoCell
            cell?.configure(with: model)
            return cell ?? UICollectionViewCell()
        }.disposed(by: disposeBag)
    }
}

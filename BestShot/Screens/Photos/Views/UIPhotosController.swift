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
    
    private let searchView: UISearchViewProtocol = {
        return UISearchView()
    }()
    
    private lazy var collectionView : UICollectionView = {
        let collection = UICollectionView(frame: .zero , collectionViewLayout: collectionViewLayout)
        collection.allowsMultipleSelection = false
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.accessibilityIdentifier = "PhotosCollection"
        return collection
    }()
    
    private lazy var collectionViewLayout : UIDynamicCollectionLayout = {
        let layout = UIDynamicCollectionLayout()
        layout.delegate = self
        return layout
    }()
    
    private let activityIndicatorView : UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.color = .appColor
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindingViewModel()
        viewModel.searchPhotos()
    }
    
    private func setupViews(){
        view.backgroundColor = .white
        view.addSubviews(contentOf: [searchView, collectionView, activityIndicatorView])
        collectionView.register(UIPhotoCell.self)
        setupConstraints()
    }
    
    private func setupConstraints(){
        searchView.snp.makeConstraints{ maker in
            maker.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            maker.leading.equalToSuperview().offset(10)
            maker.trailing.equalToSuperview().offset(-10)
            maker.height.equalTo(50)
        }
        collectionView.snp.makeConstraints{ maker in
            maker.top.equalTo(searchView.snp.bottom).offset(10)
            maker.leading.equalToSuperview().offset(10)
            maker.bottom.trailing.equalToSuperview().offset(-10)
        }
        activityIndicatorView.snp.makeConstraints{ maker in
            maker.size.equalTo(25)
            maker.center.equalToSuperview()
        }
    }
    
    private func bindingViewModel(){
        bindingPhotos()
        bindingCollectionViewDataSource()
        bindingToSearchQuery()
        bindingCollectionViewScrollingEvent()
        bindingHistorySearchTrigger()
        bindingHistorySearchItemsToSearchView()
        bindindLoadingIndicator()
        bindingErrorMessage()
    }
    
    private func bindingPhotos(){
        viewModel.photos
        .filter{$0.count > 0}
        .subscribe(onNext: {[weak self] items in
           self?.collectionView.clearMessage()
           self?.collectionViewLayout.invalidateLayout()
        }).disposed(by: disposeBag)
    }
    
    private func bindingCollectionViewDataSource(){
        viewModel.photos
        .bind(to: collectionView.rx.items){(collection, index , model) in
            let target = IndexPath(row: index, section: 0)
            let cell = collection.dequeueReusableCell(with: UIPhotoCell.self, for: target)  as? UIPhotoCell
            cell?.configure(with: model)
            return cell ?? UICollectionViewCell()
        }.disposed(by: disposeBag)
    }
    
    private func bindingToSearchQuery(){
        searchView.searchQuery
       .bind(to: viewModel.searchQuery)
       .disposed(by: disposeBag)
    }
    
    private func bindingCollectionViewScrollingEvent(){
         collectionView.rx.reachedBottom
        .bind(to: viewModel.reachedBottomTrigger)
        .disposed(by: disposeBag)
    }
    
    private func bindingHistorySearchTrigger(){
         searchView.loadHistorySearchTrigger
        .bind(to: viewModel.loadHistorySearchTrigger)
        .disposed(by: disposeBag)
    }
    
    private func bindingHistorySearchItemsToSearchView(){
        viewModel.historySearchItems
        .bind(to: searchView.items)
        .disposed(by: disposeBag)
    }
    
    private func bindingErrorMessage(){
        viewModel.error
        .observe(on: MainScheduler.instance)
        .compactMap{$0}
        .subscribe(onNext: {[weak self] error in
            self?.collectionView.setMessage(with: error)
        }).disposed(by: disposeBag)
    }
    
    func bindindLoadingIndicator()  {
        viewModel.isLoading
       .observe(on: MainScheduler.instance)
       .subscribe(onNext:{[weak self] status in
           guard !(self?.viewModel.isLoadingMore.value ?? false) else {return}
           let indicator = self?.activityIndicatorView
           _ = status ? indicator?.startAnimating() : indicator?.stopAnimating()
       }).disposed(by: disposeBag)
    }
}

extension UIPhotosController: UIDynamicCollectionLayoutDelegate{
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath, cellWidth: CGFloat) -> CGFloat {
        let sourceImage = viewModel.photos.value[indexPath.row]
        let scaleFactor = cellWidth / sourceImage.width
        let imgHeight = sourceImage.height * scaleFactor
        return (imgHeight + padding)
    }
}

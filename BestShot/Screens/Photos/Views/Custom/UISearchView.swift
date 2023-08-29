//
//  UISearchView.swift
//  BestShot
//
//  Created by Mohannad on 29/08/2023.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

protocol UISearchViewProtocol: UIView{
    var searchQuery: PublishSubject<String?>{get}
    var loadHistorySearchTrigger: PublishSubject<Void>{get}
    var items: BehaviorRelay<[String]>{get}
}

final class UISearchView: UIView, UISearchViewProtocol {
    var searchQuery = PublishSubject<String?>()
    var loadHistorySearchTrigger = PublishSubject<Void>()
    var items = BehaviorRelay<[String]>(value: []) //Input event
   

    private let searchBarView: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.layer.cornerRadius = 25
        searchBar.layer.borderColor =  UIColor.gray.cgColor
        searchBar.layer.borderWidth = 1
        searchBar.searchTextField.borderStyle = .none
        searchBar.placeholder = "Search"
        searchBar.showsCancelButton = true
        searchBar.tintColor = .gray
        return searchBar
    }()
    
    private lazy var tableView : UITableView = {
        let table = UITableView()
        table.allowsMultipleSelection = false
        table.rowHeight = historyItemHeight
        table.backgroundColor = .clear
        table.layer.cornerRadius = 15
        table.clipsToBounds = true
        table.tableFooterView = UIView()
        table.bounces = false
        table.alwaysBounceVertical = false
        return table
    }()
    
    private let disposeBag = DisposeBag()
    private let historyItemHeight = 40.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        bindingSearchBarEvents()
        bindingHistoryItemsToTableView()
        bindingSelectHistoryTableviewItem()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(){
        addSubview(searchBarView)
        tableView.register(UISearchHistoryCell.self)
        tableView.separatorStyle = .none
        setupViewsConstraints()
    }
    
    private func setupViewsConstraints(){
        searchBarView.snp.makeConstraints{$0.edges.equalToSuperview()}
    }
    
    private func bindingSearchBarEvents(){
        searchBarView.rx.searchButtonClicked
        .subscribe(onNext: {[weak self] item in
            self?.searchBarView.endEditing(true)
            self?.searchQuery.on(.next(self?.searchBarView.text))
        }).disposed(by: disposeBag)
        
        searchBarView.rx.cancelButtonClicked
        .subscribe(onNext: {[weak self] item in
            self?.searchBarView.endEditing(true)
        }).disposed(by: disposeBag)
        
        searchBarView.rx.textDidBeginEditing
        .subscribe(onNext: {[weak self] _ in
            guard let self = self  else {return }
            self.loadHistorySearchTrigger.onNext(())
            self.showHistoryTableview()
        }).disposed(by: disposeBag)
        
        searchBarView.rx.textDidEndEditing
        .subscribe(onNext: {[weak self] _ in
                self?.tableView.removeFromSuperview()
            _ = self?.tableView.constraints.map{$0.isActive = false}
        }).disposed(by: disposeBag)
    }
    
    private func bindingHistoryItemsToTableView(){
        items.bind(to: tableView.rx.items){ (table , row , model) in
            let cell = table.dequeueReusableCell(with: UISearchHistoryCell.self, for: IndexPath(row: row, section: 0)) as? UISearchHistoryCell
            cell?.configure(with: model)
            return cell ?? UITableViewCell()
        }.disposed(by: disposeBag)
    }
    
    private func showHistoryTableview(){
       
        superview?.addSubview(tableView)
        tableView.separatorStyle = .none
        let height = min((5 * historyItemHeight), (CGFloat(items.value.count) * historyItemHeight))
        tableView.snp.makeConstraints{ make in
            make.top.equalTo(self.snp.bottom).offset(5)
            make.trailing.equalToSuperview().offset(-10)
            make.leading.equalToSuperview().offset(10)
            make.height.equalTo(height)
        }
        superview?.bringSubviewToFront(tableView)
    }
    
    private func bindingSelectHistoryTableviewItem(){
       tableView.rx.modelSelected(String.self)
       .subscribe(onNext : {[weak self] selectedItem in
           self?.searchBarView.endEditing(true)
           self?.searchBarView.text = selectedItem
           self?.searchQuery.onNext(selectedItem)
       }).disposed(by: disposeBag)
    }
}

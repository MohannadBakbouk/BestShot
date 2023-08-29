//
//  UIBaseViewController.swift
//  BestShot
//
//  Created by Mohannad on 29/08/2023.
//

import UIKit
import RxSwift

class UIBaseViewController<VM: BaseViewModelProtocol>: UIViewController {
    let disposeBag = DisposeBag()
    weak var coordinator: Coordinator?
    let viewModel: VM!
    
    init(viewModel: VM!, coordinator: Coordinator?) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

//
//  UISplashController.swift
//  BestShot
//
//  Created by Mohannad on 29/08/2023.
//

import UIKit
import SnapKit

final class UISplashController: UIViewController {
    
    weak var coordinator : MainCoordinator?
    
    private var inidicatorView:  UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .appColor
        activityIndicator.style = .large
        activityIndicator.accessibilityIdentifier = "InidicatorView"
        return activityIndicator
    }()
    
    private var slugLabel : UILabel = {
        let label = UILabel()
        label.text = "Best Shot"
        label.textColor = .appColor
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.accessibilityIdentifier = "SlugLabel"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        routeToNextScreen()
    }
    
    private func setupViews(){
        view.backgroundColor = .white
        view.addSubviews(contentOf: [slugLabel , inidicatorView])
        setupConstrains()
    }
    
    private func setupConstrains(){
        slugLabel.snp.makeConstraints { maker in
            maker.centerX.equalTo(view.snp.centerX)
            maker.centerY.equalTo(view.snp.centerY).offset(-50)
        }
        
        inidicatorView.snp.makeConstraints { maker in
            maker.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50)
            maker.centerX.equalToSuperview()
        }
    }
    
    private func routeToNextScreen()  {
        inidicatorView.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {[weak self]  in
            self?.coordinator?.showPhotos()
        }
    }
}

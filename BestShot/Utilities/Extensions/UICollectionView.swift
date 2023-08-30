//
//  UICollectionView.swift
//  BestShot
//
//  Created by Mohannad on 29/08/2023.
//

import UIKit
extension UICollectionView{
    func register(_ cellClass: AnyClass){
        register(cellClass, forCellWithReuseIdentifier: String(describing: cellClass.self))
       
    }
    
    func dequeueReusableCell(with cellClass: AnyClass, for indexPath: IndexPath) -> UICollectionViewCell?{
        dequeueReusableCell(withReuseIdentifier: String(describing: cellClass.self), for: indexPath)
    }
    
    func setMessage(with info : ErrorDataView){
        setMessage(info.message, icon: info.icon)
    }
    
    func setMessage(_ message : String , icon : String = Images.exclamationmark){
        let view = UIView()
        backgroundView = view
        
        let messageLabel = UILabel()
        messageLabel.textAlignment = .center
        messageLabel.textColor = .lightGray
        messageLabel.numberOfLines = 2
        messageLabel.lineBreakMode = .byTruncatingMiddle
        messageLabel.text = message
        view.addSubview(messageLabel)

        let imageView  = UIImageView()
        imageView.image = UIImage(systemName : icon)
        imageView.tintColor = .lightGray
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints { maker in
            maker.width.height.equalTo(50)
            maker.centerX.equalTo(view.snp.centerX)
            maker.centerY.equalTo(view.snp.centerY).offset(-75)
        }
        
        messageLabel.snp.makeConstraints { maker in
            maker.height.equalTo(60)
            maker.leading.equalTo(view.snp.leading).offset(10)
            maker.trailing.equalTo(view.snp.trailing).offset(-10)
            maker.top.equalTo(imageView.snp.bottom).offset(10)
        }
    }
    
    func clearMessage(){
        backgroundView = nil
    }
}

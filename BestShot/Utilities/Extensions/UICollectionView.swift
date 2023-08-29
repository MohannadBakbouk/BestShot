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
}

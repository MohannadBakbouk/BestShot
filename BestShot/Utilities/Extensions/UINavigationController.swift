//
//  UINavigationController.swift
//  BestShot
//
//  Created by Mohannad on 29/08/2023.
//

import UIKit

extension UINavigationController{
    convenience init(hideBar : Bool){
        self.init()
        navigationBar.isHidden = hideBar
    }
}

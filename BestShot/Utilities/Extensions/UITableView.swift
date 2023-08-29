//
//  UITableView.swift
//  BestShot
//
//  Created by Mohannad on 29/08/2023.
//

import UIKit

extension UITableView{
    func register(_ cellClass: AnyClass){
        register(cellClass, forCellReuseIdentifier: String(describing: cellClass.self))
    }

    func dequeueReusableCell(with cellClass: AnyClass, for indexPath: IndexPath) -> UITableViewCell?{
        dequeueReusableCell(withIdentifier: String(describing: cellClass.self), for: indexPath)
    }
}

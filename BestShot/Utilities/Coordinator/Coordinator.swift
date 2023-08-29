//
//  Coordinator.swift
//  BestShot
//
//  Created by Mohannad on 29/08/2023.
//

import UIKit

protocol Coordinator: AnyObject {
    var  childCoordinators : [Coordinator] {get set}
    var  navigationController : UINavigationController {get set}
    func start()
    func back()
    func dismiss()
}

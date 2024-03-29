//
//  MainCoordinator.swift
//  BestShot
//
//  Created by Mohannad on 29/08/2023.
//

import UIKit

final class MainCoordinator: Coordinator{
    
    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController
    
    init(navigation : UINavigationController) {
        childCoordinators = []
        navigationController = navigation
    }
    
    func start() {
        let splash = UISplashController()
        splash.coordinator = self
        pushViewControllerToStack(with: splash)
    }
    
    func showPhotos(){
        let cacheManager = CacheManager(modelName: DefaultSettings.modelName)
        let viewModel = PhotosViewModel(service: PhotoService(), cacheManager: cacheManager)
        let photosScreen = UIPhotosController(viewModel: viewModel, coordinator: self)
        pushViewControllerToStack(with:photosScreen, animated: false, isRoot: true)
    }
    
    func back() {
        navigationController.popViewController(animated: true)
    }
    
    func dismiss() {
        navigationController.dismiss(animated: true)
    }
}

extension MainCoordinator {
    func pushViewControllerToStack(with value : UIViewController , animated : Bool = true ,  isRoot: Bool = false){
        _ = isRoot ? navigationController.setViewControllers([], animated: false) : ()
        navigationController.pushViewController(value, animated: animated)
    }
}

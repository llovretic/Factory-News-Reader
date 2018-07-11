//
//  BaseCoordinator.swift
//  Factory News Reader
//
//  Created by Luka Lovretic on 11/07/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import UIKit

class BaseCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var presenter: UINavigationController
    let service: APIRepository
    let controller: BaseViewController
    
    init(presenter: UINavigationController, services: APIRepository){
        self.presenter = presenter
        self.service = services
        let baseViewController = BaseViewController()
        self.controller = baseViewController
    }
    
    func start() {
        
        presenter.pushViewController(controller, animated: true)
        
//        let tabBarController = BaseViewController()
//
//        let listNewsCoordinator = ListNewsCoordinator(presenter: presenter)
//        listNewsCoordinator.start()
//
//        let favouriteNewsCoordinator = FavouriteNewsCoordinator(presenter: presenter)
//
//        tabBarController.setViewControllers([listNewsCoordinator.controller, favouriteNewsCoordinator.controller], animated: false)
    }
}

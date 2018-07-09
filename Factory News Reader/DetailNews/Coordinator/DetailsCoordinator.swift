//
//  DetailsCoordinator.swift
//  Factory News Reader
//
//  Created by Luka Lovretić on 09/07/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import UIKit

class DetailsCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var presenter: UINavigationController
    private let controller: NewsDetailViewController
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        let detailsController = NewsDetailViewController()
        self.controller = detailsController
    }
    
    
    func start() {
//        let coordinator = DetailsCoordinator(navigationController: navigationController)
//        coordinator.start()
//        childCoordinators.append(coordinator)
        let viewController = NewsDetailViewController()
        presenter.pushViewController(viewController, animated: true)
        
    }
}

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
    let controller: NewsDetailViewController
    weak var parentCoordinatorDelegate: ParentCoordinatorDelegate?

    
    init(presenter: UINavigationController, news: NewsViewData) {
        self.presenter = presenter
        let detailsController = NewsDetailViewController()
        let viewModel = NewsDetailViewModel()
        viewModel.newsDetailData = news
        detailsController.newsDetailViewModel = viewModel
        self.controller = detailsController
        
    }
    
    deinit {
        print("deinit details coordinator")
    }
    
    
    func start() {
        presenter.pushViewController(controller, animated: true)
    }
}
extension DetailsCoordinator: ParentCoordinatorDelegate {
    func childHasFinished(coordinator: Coordinator) {
        removeChildCoordinator(childCoordinator: coordinator)
    }
}

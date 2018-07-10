//
//  DetailsCoordinator.swift
//  Factory News Reader
//
//  Created by Luka Lovretić on 09/07/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import UIKit

class SingleNewsCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var presenter: UINavigationController
    let singleNewsController: SingleNewsViewController
    weak var parentCoordinatorDelegate: ParentCoordinatorDelegate?

    
    init(presenter: UINavigationController, news: NewsData) {
        self.presenter = presenter
        let singleNewsController = SingleNewsViewController()
        let singleNewsViewModel = SingleNewsViewModel()
        singleNewsViewModel.newsDetailData = news
        singleNewsController.singlelNewsViewModel = singleNewsViewModel
        self.singleNewsController = singleNewsController
        
    }
    
    deinit {
        print("deinit details coordinator")
    }
    
    
    func start() {
        presenter.pushViewController(singleNewsController, animated: true)
    }
}
extension SingleNewsCoordinator: ParentCoordinatorDelegate {
    func childHasFinished(coordinator: Coordinator) {
        removeChildCoordinator(childCoordinator: coordinator)
    }
}

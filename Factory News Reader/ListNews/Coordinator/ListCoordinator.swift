//
//  ListCoordinator.swift
//  Factory News Reader
///Users/llovretic/Desktop/Praksa-iOS/Factory-News-Reader/Factory News Reader/Coordinators/Coordinator.swift
//  Created by Luka Lovretić on 09/07/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import UIKit

class ListCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var presenter: UINavigationController
    private let controller: NewsListViewController
    weak var parentCoordinatorDelegate: ParentCoordinatorDelegate?
    
    init(presenter: UINavigationController){
        self.presenter = presenter
        let listController = NewsListViewController()
        let viewModel = NewsListViewModel(newsService: APIService())
        listController.newsListViewModel = viewModel
        self.controller = listController
    }
    
    func start() {
        presenter.pushViewController(controller, animated: true)
    }
    
}

extension ListCoordinator: ListCoordinatorDelegate{
    func openDetailNews(selectedNews: NewsViewData) {
        let coordinator = DetailsCoordinator(presenter: presenter)
        coordinator.parentCoordinatorDelegate = self
        addChildCoordinator(childCoordinator: coordinator)
        coordinator.start()
    }
    
    func viewControllerHasFinished() {
        childCoordinators.removeAll()
        parentCoordinatorDelegate?.childHasFinished(coordinator: self)
    }
}

extension ListCoordinator: ParentCoordinatorDelegate{
    func childHasFinished(coordinator: Coordinator) {
        removeChildCoordinator(childCoordinator: coordinator)
    }
 
}

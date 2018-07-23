//
//  ListCoordinator.swift
//  Factory News Reader
///Users/llovretic/Desktop/Praksa-iOS/Factory-News-Reader/Factory News Reader/Coordinators/Coordinator.swift
//  Created by Luka Lovretić on 09/07/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import UIKit

class ListNewsCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var presenter: UINavigationController
    let controller: ListNewsViewController
    weak var parentCoordinatorDelegate: ParentCoordinatorDelegate?
    
    init(presenter: UINavigationController){
        self.presenter = presenter
        let listNewsController = ListNewsViewController()
        let listNewsviewModel = ListNewsViewModel(newsService: APIRepository())
        listNewsController.listNewsViewModel = listNewsviewModel
        self.controller = listNewsController
    }
    
    deinit {
    }
    
    func start() {
        controller.listNewsViewModel.listNewsCoordinatorDelegate = self
        presenter.pushViewController(controller, animated: true)
    }
    
}

extension ListNewsCoordinator: ListNewsCoordinatorDelegate{
    func openSingleNews(selectedNews: NewsData) {
        let coordinator = SingleNewsCoordinator(presenter: presenter, news: selectedNews)
        coordinator.parentCoordinatorDelegate = self
        coordinator.start()
        self.addChildCoordinator(childCoordinator: coordinator)
        
    }
    
    func viewControllerHasFinished() {
        childCoordinators.removeAll()
        parentCoordinatorDelegate?.childHasFinished(coordinator: self)
    }
}

extension ListNewsCoordinator: ParentCoordinatorDelegate{
    func childHasFinished(coordinator: Coordinator) {
        removeChildCoordinator(childCoordinator: coordinator)
    }
 
}

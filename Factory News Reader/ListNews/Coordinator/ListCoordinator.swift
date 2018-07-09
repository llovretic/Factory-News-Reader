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
//        controller.newsListViewModel.
        presenter.pushViewController(controller, animated: true)
//        let coordinator = ListCoordinator(navigationController: navigationController)
//        coordinator.start()
//        childCoordinators.append(coordinator)
    }
    
//    func stop() {
//        _ = navigationController?.popViewController(animated: true)
//        appCoordinator?.listCoordinatorCompleted(coordinator: self)
//    }
}

extension ListCoordinator: ListCoordinatorDelegate{
    func newsListDidSelectNews(selectedNews: NewsViewData) {
        
    }
    
    func viewControllerHasFinished() {
        childCoordinators.removeAll()
        parentCoordinatorDelegate?.childHasFinished(coordinator: self)
    }
    
    
}

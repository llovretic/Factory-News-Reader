//
//  AppCoordinator.swift
//  Factory News Reader
//
//  Created by Luka Lovretić on 09/07/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator{
    
    var childCoordinators: [Coordinator] = []
    var presenter: UINavigationController
    private let controller: NewsListViewController
    
    init(presneter: UINavigationController){
        self.presenter = presneter
        let listController = NewsListViewController()
        let viewModel = NewsListViewModel(newsService: APIService())
        listController.newsListViewModel = viewModel
        self.controller = listController
    }
    
    func start(){
//        controller.newsListViewModel
        presenter.pushViewController(controller, animated: true)
//        let coordinator = ListCoordinator(presenter: presenter)
//        coordinator.start()
//        childCoordinators.append(coordinator)
//        print(childCoordinators)
    }
}


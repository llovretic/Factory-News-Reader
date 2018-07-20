//
//  FavouriteNewsCoordinator.swift
//  Factory News Reader
//
//  Created by Luka Lovretic on 11/07/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import UIKit

class FavouriteNewsCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var presenter: UINavigationController
    let controller: FavouriteNewsViewController
    weak var parentCoordinatorDelegate: ParentCoordinatorDelegate?
    
    init(presenter: UINavigationController){
        self.presenter = presenter
        let favouriteNewsController = FavouriteNewsViewController()
        let favouriteNewsViewModel = FavouriteNewsViewModel()
        favouriteNewsController.favouriteNewsViewModel = favouriteNewsViewModel
        self.controller = favouriteNewsController
        controller.favouriteNewsViewModel.favouriteNewsCoordinatorDelegate = self
    }
    
    deinit {
        print("deinit list coordinator")
    }
    
    func start() {
        presenter.pushViewController(controller, animated: true)
    }
    
}

extension FavouriteNewsCoordinator: ListNewsCoordinatorDelegate{
    func openSingleNews(selectedNews: NewsData) {
        print("openSingleNewsInitiated")
        let newsDetailCoordinator = SingleNewsCoordinator(presenter: self.presenter, news: selectedNews)
        print(newsDetailCoordinator)
        newsDetailCoordinator.start()
        self.addChildCoordinator(childCoordinator: newsDetailCoordinator)
    }
    
    func viewControllerHasFinished() {
        self.childCoordinators.removeAll()
        parentCoordinatorDelegate?.childHasFinished(coordinator: self)
    }
    
    
}

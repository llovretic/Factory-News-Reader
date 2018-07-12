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
//        let listNewsviewModel = ListNewsViewModel(newsService: APIRepository())
//        listNewsController.listNewsViewModel = listNewsviewModel
        self.controller = favouriteNewsController
    }
    
    deinit {
        print("deinit list coordinator")
    }
    
    func start() {
        presenter.pushViewController(controller, animated: true)
    }
    
}

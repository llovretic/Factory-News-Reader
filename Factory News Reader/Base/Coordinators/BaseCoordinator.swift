//
//  BaseCoordinator.swift
//  Factory News Reader
//
//  Created by Luka Lovretic on 11/07/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import UIKit

class BaseCoordinator: Coordinator  {
    var presenter: UINavigationController
    var childCoordinators: [Coordinator] = []
    let controller: BaseViewController
    weak var baseCoordinatorDelegate: BaseCoordinatorDelegate!
    
    init(presenter: UINavigationController){
        self.presenter = presenter
        let baseViewController = BaseViewController()
        self.controller = baseViewController
        
        let favouriteNewsCoordinator = FavouriteNewsCoordinator(presenter: presenter)
        let favouriteNewsNavigationController = createNavigationController(viewController: favouriteNewsCoordinator.controller, image: UIImage(named: "favouritesList")!, title: "FAVOURITES")
    
        
        let listNewsCoordinator = ListNewsCoordinator(presenter: presenter)
        let listNewsNavigationController = createNavigationController(viewController: listNewsCoordinator.controller, image: UIImage(named: "newsList")!, title: "NEWS")
        

        listNewsCoordinator.controller.listNewsViewModel.listNewsCoordinatorDelegate = listNewsCoordinator
    
        self.controller.setViewControllers([listNewsNavigationController,favouriteNewsNavigationController], animated: false)
    }
    
    func start() {
        presenter.pushViewController(controller, animated: true)
    }
    
    func createNavigationController(viewController: UIViewController, image: UIImage, title: String) -> UINavigationController{
        let viewController = viewController
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.image = image
        navigationController.tabBarItem.title = title
        return navigationController
    }
}


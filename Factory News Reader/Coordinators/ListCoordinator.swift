//
//  ListCoordinator.swift
//  Factory News Reader
//
//  Created by Luka Lovretić on 09/07/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import UIKit

class ListCoordinator: Coordinator {
    var appCoordinator: AppCoordinator?
    
    convenience init(navigationController: UINavigationController?, appCoordinator: AppCoordinator?){
        self.init(navigationController: navigationController)
        self.appCoordinator = appCoordinator
    }
    
    func start() {
        let viewController = NewsListViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }

    func stop() {
        _ = navigationController?.popViewController(animated: true)
        appCoordinator?.listCoordinatorCompleted(coordinator: self)
    }
}

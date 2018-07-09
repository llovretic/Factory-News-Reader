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
        self.controller = NewsListViewController()
        
    }
    
    func start(){
        let controller = NewsListViewController()
        presenter.pushViewController(controller, animated: true)
    }
}


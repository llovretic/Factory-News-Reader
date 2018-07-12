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

    init(presneter: UINavigationController){
        self.presenter = presneter
    }
    
    func start(){
        let tabBarCoordinator = BaseCoordinator(presenter: presenter)
        tabBarCoordinator.start()
        
//        let coordinator = ListNewsCoordinator(presenter: presenter)
//        coordinator.start()
//        self.addChildCoordinator(childCoordinator: coordinator)
    }
}


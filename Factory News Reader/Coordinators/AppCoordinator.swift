//
//  AppCoordinator.swift
//  Factory News Reader
//
//  Created by Luka Lovretić on 09/07/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator{
    
    func start(){
        let coordinator = ListCoordinator(navigationController: navigationController)
        coordinator.start()
        childCoordinators.append(coordinator)
    }
    
    func listCoordinatorCompleted(coordinator: ListCoordinator){
        if let index = childCoordinators.index(where: { $0 === coordinator}){
            childCoordinators.remove(at: index)
        }
    }
        
    func detailsCoordinatorCompleted(coordinator: DetailsCoordinator){
            if let index = childCoordinators.index(where: { $0 === coordinator}){
                childCoordinators.remove(at: index)
            }
    }
}

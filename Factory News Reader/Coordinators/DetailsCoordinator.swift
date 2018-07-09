//
//  DetailsCoordinator.swift
//  Factory News Reader
//
//  Created by Luka Lovretić on 09/07/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import UIKit

class DetailsCoordinator: Coordinator {
    
    func start() {
        let viewController = NewsDetailViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

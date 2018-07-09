//
//  Coordinator.swift
//  Factory News Reader
//
//  Created by Luka Lovretić on 09/07/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import Foundation
import UIKit

class Coordinator {
    var childCoordinators: [Coordinator] = []
    weak var navigationController = UINavigationController()
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController!
    }
}

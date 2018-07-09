//
//  DetailsCoordinator.swift
//  Factory News Reader
//
//  Created by Luka Lovretić on 09/07/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import UIKit

class DetailsCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var presenter: UINavigationController
    private let controller: NewsDetailViewController
    weak var parentCoordinatorDelegate: ParentCoordinatorDelegate?

    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        let detailsController = NewsDetailViewController()
        let viewModel = NewsDetailViewModel()
        detailsController.newsDetailViewModel = viewModel
        self.controller = detailsController
    }
    
    
    func start() {
        presenter.pushViewController(controller, animated: true)
    }
}

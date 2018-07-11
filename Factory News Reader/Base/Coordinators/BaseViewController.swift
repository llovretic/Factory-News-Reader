//
//  BaseViewController.swift
//  Factory News Reader
//
//  Created by Luka Lovretic on 11/07/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import UIKit

class BaseViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.barTintColor = UIColor.blue
        setupTabBar()
        
    }
    func setupTabBar() {
        
        let listNewsController = createNavController(vc: ListNewsViewController(), selected: #imageLiteral(resourceName: "video_white"), unselected: #imageLiteral(resourceName: "video_black"))
        let favoriteController = createNavController(vc: FavouriteNewsViewController(), selected: #imageLiteral(resourceName: "star_white"), unselected: #imageLiteral(resourceName: "star_black"))
        
        viewControllers = [listNewsController, favoriteController]
        
        guard let items = tabBar.items else { return }
        
        for item in items {
            item.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0)
        }
    }
}
extension UITabBarController {
    
    func createNavController(vc: UIViewController, selected: UIImage, unselected: UIImage) -> UINavigationController {
        let viewController = vc
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselected
        navController.tabBarItem.selectedImage = selected
        return navController
    }
}


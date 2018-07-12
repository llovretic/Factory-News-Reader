//
//  BaseViewController.swift
//  Factory News Reader
//
//  Created by Luka Lovretic on 11/07/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import UIKit
import RxSwift

class BaseViewController: UITabBarController {
    
    var baseViewModel: BaseViewModel!
    
    var listNewsController: ListNewsViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tabBar.barTintColor = UIColor.blue
        navigationItem.title = "Factory"
        
    }
}

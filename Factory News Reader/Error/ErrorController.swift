//
//  Greska.swift
//  Factory News Reader
//
//  Created by Luka Lovretic on 12/06/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import UIKit

class ErrorController: UIAlertController {
    //MARK: postavljanje alerta
    class func alert(viewToPresent: UIViewController, title: String, message: String) -> Void
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "U redu", style: .default)
//        { (action:UIAlertAction!) in
//
//        }
        alert.addAction(action)
        viewToPresent.present(alert, animated: true, completion:nil)
    }
}

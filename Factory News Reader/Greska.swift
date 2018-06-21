//
//  Greska.swift
//  Factory News Reader
//
//  Created by Luka Lovretic on 12/06/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import UIKit

class Greska: UIAlertController {
    //MARK: postavljanje alerta
    class func alert(title: String, message: String) -> Void
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let akcija = UIAlertAction(title: "U redu", style: .default) { (action:UIAlertAction!) in
            // PITATI U PETAK KAKO BI KORISTILI getData() U ALERTU NAKON CLICKA NA BUTtON
        }
        
        alert.addAction(akcija)
        alert.present(alert, animated: true, completion:nil)
    }
}

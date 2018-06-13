//
//  GreskaViewController.swift
//  Factory News Reader
//
//  Created by Luka Lovretic on 12/06/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import UIKit

class GreskaViewController: UIAlertController{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func alert(){
        let alert = UIAlertController(title: "Greška", message: "Ups, došlo je do pogreške.", preferredStyle: .alert)
        let akcija = UIAlertAction(title: "U redu", style: .default) {(actions) in
            print("Alert dismisan")}
        alert.addAction(akcija)
        self.present(alert, animated: true, completion: nil)
    }

}

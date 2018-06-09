//
//  DetaljniPrikazViewController.swift
//  Factory News Reader
//
//  Created by Luka Lovretic on 09/06/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import UIKit

class DetaljniPrikazViewController: UIViewController {
    
    var slika: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var naslov: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var vijestTekst: UITextView = {
        let tekst = UITextView()
        tekst.translatesAutoresizingMaskIntoConstraints = false
        tekst.isEditable = false
        tekst.isScrollEnabled = true
        return tekst
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        view.backgroundColor = UIColor.white
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
     func addSubViews() {
        self.view.addSubview(slika)
        slika.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        slika.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        slika.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        slika.widthAnchor.constraint(equalToConstant: 80).isActive = true
//        slika.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        
        self.view.addSubview(naslov)
        naslov.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        naslov.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 8).isActive = true
        naslov.topAnchor.constraint(equalTo: slika.bottomAnchor, constant: 8).isActive = true
        
        
        self.view.addSubview(vijestTekst)
        vijestTekst.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        vijestTekst.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 8).isActive = true
        vijestTekst.topAnchor.constraint(equalTo: naslov.bottomAnchor, constant: 8).isActive = true
    
    }
    

}

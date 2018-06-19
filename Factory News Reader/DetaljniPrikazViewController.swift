//
//  DetaljniPrikazViewController.swift
//  Factory News Reader
//
//  Created by Luka Lovretic on 09/06/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import UIKit

class DetaljniPrikazViewController: UIViewController {
    //MARK: varijable 
    var slika: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
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
    
    var podaci: VijestiViewData!

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
    
    //MARK: layout postavke
     func addSubViews() {
        
        view.addSubview(slika)
        if let imageURL = URL(string: podaci.urlToImage) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.slika.image = image
                    }
                }
            }
        }
        slika.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        slika.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        slika.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        slika.widthAnchor.constraint(equalToConstant: 80).isActive = true
        slika.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        view.addSubview(naslov)
        naslov.text = podaci.title
        naslov.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        naslov.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        naslov.topAnchor.constraint(equalTo: view.topAnchor, constant: 308).isActive = true
        naslov.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 360) .isActive = true
        
      
        view.addSubview(vijestTekst)
        vijestTekst.text = podaci.description
        vijestTekst.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        vijestTekst.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        vijestTekst.topAnchor.constraint(equalTo: naslov.bottomAnchor, constant: 8).isActive = true
        vijestTekst.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        navigationItem.title = podaci.title
        
        
    
    }
    

}

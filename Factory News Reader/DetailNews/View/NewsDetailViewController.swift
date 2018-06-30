//
//  DetaljniPrikazViewController.swift
//  Factory News Reader
//
//  Created by Luka Lovretic on 09/06/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController {
    //MARK: varijable
    var newsPresenter: NewsDetailPresenter!
    
    var newsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var newsTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var newsDescription: UITextView = {
        let tekst = UITextView()
        tekst.translatesAutoresizingMaskIntoConstraints = false
        tekst.isEditable = false
        tekst.isScrollEnabled = true
        return tekst
    }()
    
    var data: [NewsViewData] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        newsPresenter.attachView(self)
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
        view.addSubview(newsImage)
        if let imageURL = URL(string: newsPresenter.newsDetailData.urlToImage) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.newsImage.image = image
                    }
                }
            }
        }
        newsImage.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        newsImage.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        newsImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        slika.widthAnchor.constraint(equalToConstant: 80).isActive = true
        newsImage.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        view.addSubview(newsTitle)
        newsTitle.text = newsPresenter.newsDetailData.title
        newsTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        newsTitle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        newsTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 308).isActive = true
        newsTitle.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 360) .isActive = true
        
      
        view.addSubview(newsDescription)
        newsDescription.text = newsPresenter.newsDetailData.description
        newsDescription.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        newsDescription.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        newsDescription.topAnchor.constraint(equalTo: newsTitle.bottomAnchor, constant: 8).isActive = true
        newsDescription.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        navigationItem.title = newsPresenter.newsDetailData.title
        
    }

}
extension NewsDetailViewController: NewsDetailView{
}





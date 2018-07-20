//
//  DetaljniPrikazViewController.swift
//  Factory News Reader
//
//  Created by Luka Lovretic on 09/06/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import UIKit

class SingleNewsViewController: UIViewController {
    //MARK: varijable
    weak var newsViewCellDelegate: NewsViewCellDelegate?
    var singlelNewsViewModel: SingleNewsViewModel!
    
    var newsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var newsTitle: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var newsDescription: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.font = .italicSystemFont(ofSize: 18)
        return textView
    }()
    
    var favouriteButton: UIButton = {
        let barButton = UIButton()
        barButton.setBackgroundImage(#imageLiteral(resourceName: "favouriteUnselected"), for: .normal)
        barButton.setBackgroundImage(#imageLiteral(resourceName: "favouriteSelected"), for: .selected)
        return barButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        view.backgroundColor = UIColor.white
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if self.isMovingFromParentViewController {
            singlelNewsViewModel.listNewsCoordinatorDelegate?.viewControllerHasFinished()
        }
    }
    
    deinit {
        print("Single News deinit")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: layout postavke
    func addSubViews() {
        view.addSubview(newsImage)
        if let imageURL = URL(string: singlelNewsViewModel.newsDetailData.urlToImage!) {
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
        newsImage.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        view.addSubview(newsTitle)
        newsTitle.text = singlelNewsViewModel.newsDetailData.title
        newsTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        newsTitle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        newsTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 308).isActive = true
        newsTitle.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 360) .isActive = true
        
        
        view.addSubview(newsDescription)
        newsDescription.text = singlelNewsViewModel.newsDetailData.descriptionNews
        newsDescription.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        newsDescription.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        newsDescription.topAnchor.constraint(equalTo: newsTitle.bottomAnchor, constant: 8).isActive = true
        newsDescription.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favouriteButton)
        favouriteButton.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
        favouriteButton.isSelected = singlelNewsViewModel.newsDetailData.isNewsFavourite
        
        navigationItem.title = singlelNewsViewModel.newsDetailData.title
    }
    
    @objc func favouriteButtonTapped() {
        favouriteButton.isSelected = singlelNewsViewModel.goThroughFavouriteNewsLogic()
    }
    
}



